########################################
#
# File Name:	API.ps1
# Date Created:	27/09/2023
# Description:	
#	Function library for common used API functions
#
########################################

# file imports
. "$($PSScriptRoot)\Common.ps1"

Add-Type -AssemblyName System.Web

# $user = ""
# $pass = ""
# $pair = "$($user):$($pass)"
# $endcodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
# $basicAuthValue = "Basic $endcodedCreds"
# $header = @{
#     Authorization = $basicAuthValue
# }

########################################
#
# Name:		Debug-API-Param
# Input:	$headingName <String>
#           $param <Various>
# Output:	Screen Output
# Description:	
#	Outputs a Debug Styled Generated Block tailored for API Paramaters, 
#   as such does a check against the data type to see if we need to convert
#   or not
#
########################################
function Debug-API-Param($headingName,$param)
{
    $heading = "API ${headingName} ($($param.GetType().Name))"
    if(($param.GetType()).Name -eq "String")
    {
        Write-Debug (Gen-Block $heading (@($param)))
    }
    else
    {
        Write-Debug (Gen-Block $heading (Hash-To-Array $param))
    }
}

########################################
#
# Name:		Call-GET
# Input:	$apiURI <String>
#           $headers <Hash Object>
# Output:	$response <JSON>
# Description:	
#	calls a GET Request from the supplied URI
#
########################################
function Call-GET($apiURI,$headers)
{
    Write-Log "Call API - ${apiURI}"
    Write-Debug (Gen-Block "API Header" (Hash-To-Array $headers))
    try
    {
        $response = Invoke-WebRequest -Uri $apiURI -Method GET -Headers $headers -ErrorAction:SilentlyContinue
    }
    catch
    {
        Write-Error "An error occurred."
        Write-Host $_.error
        Throw
    }
    return $response
}

########################################
#
# Name:		Call-POST
# Input:	$apiURI <String>
#           $headers <Hash Object>
#           $body <Various> [Optional: Empty Hash]
# Output:	$response <JSON>
# Description:	
#	calls a POST Request from the supplied URI
#
########################################
function Call-POST($apiURI,$headers,$body=@{})
{
    Write-Log "Call API - ${apiURI}"
    Debug-API-Param "Header" $headers
    Debug-API-Param "Body" $body

    $switchFlags = ""

    if($headers.Count -gt 0)
    {
        $switchFlags += "h"
    }
    if($body.Count -gt 0)
    {
        $switchFlags += "b"
    }

    Write-Debug "Invocation Flags = ${switchFlags}"

    try
    {
        switch ($switchFlags)
        {
            "h" {
                $response = Invoke-RestMethod -Uri $apiURI -Method POST -Headers $headers -ErrorAction:SilentlyContinue
                break
            }
            "b" {
                $response = Invoke-RestMethod -Uri $apiURI -Method POST -Body $body -ErrorAction:SilentlyContinue
                break
            }
            "hb" {
                $response = Invoke-RestMethod -Uri $apiURI -Method POST -Headers $headers -Body $body -ErrorAction:SilentlyContinue
                break
            }
        }
    }
    catch
    {
        Write-Error "An error occurred."
        Write-Host $_.error
        Throw
    }
    return $response
}

########################################
#
# Name:		Call-POST-Form
# Input:	$apiURI <String>
#           $headers <Hash Object>
#           $body <Hash> [Optional: Empty Hash]
# Output:	$response <JSON>
# Description:	
#	calls a POST Request from the supplied URI but passing the body as a Form Object
#
########################################
function Call-POST-Form($apiURI,$headers,$body=@{})
{
    Write-Log "Call API - ${apiURI}"
    Debug-API-Param "Header" $headers
    Debug-API-Param "Body" $body

    $switchFlags = ""

    if($headers.Count -gt 0)
    {
        $switchFlags += "h"
    }
    if($body.Count -gt 0)
    {
        $switchFlags += "b"
    }

    Write-Debug "Invocation Flags = ${switchFlags}"

    try
    {
        switch ($switchFlags)
        {
            "h" {
                $response = Invoke-WebRequest -Uri $apiURI -Method POST -Headers $headers -ErrorAction:SilentlyContinue
                break
            }
            "b" {
                $response = Invoke-WebRequest -Uri $apiURI -Method POST -Form $body -ErrorAction:SilentlyContinue
                break
            }
            "hb" {
                $response = Invoke-WebRequest -Uri $apiURI -Method POST -Headers $headers -Form $body -ErrorAction:SilentlyContinue
                break
            }
        }
    }
    catch
    {
        Write-Error "An error occurred."
        Write-Host $_.error
        Throw
    }
    return $response
}

########################################
#
# Name:		Call-POST-Form-Stream
# Input:	$apiURI <String>
#           $headers <Hash Object>
#           $body <NameValueCollection Object>
# Output:	$ret <JSON>
# Description:	
#	calls a POST Request from the supplied URI but unlike Call-POST, Invoke-RestMethod is not used
#   but instead manually creates a web request in order to pass a Form Array and processes response
#   as a StreamReader
#
########################################
function Call-POST-Form-Stream($apiURI,$headers,$body)
{
    Write-Log "Call API - ${apiURI}"
    Write-Debug (Gen-Block "API Header" (Hash-To-Array $headers))
    Write-Debug (Gen-Block "API Body" (NameValueCollection-To-Array $body))

    Write-Log "Breaking up Body"
    $params = "";    
    $i = 0;
    $j = $body.Count;
    $first = $true;
    while ($i -lt $j) 
    {       
        $key = $body.GetKey($i);
        $body.GetValues($i) | %{
            $val = $_;
            if (!$first) 
            {
                $params += "&";
            } 
            else 
            {
                $first = $false;
            }
            $params += [System.Web.HttpUtility]::UrlEncode($key) + "=" + [System.Web.HttpUtility]::UrlEncode($val);
        };
        $i++;
    }
    $b = [System.Text.Encoding]::UTF8.GetBytes($params);

    Write-Log "Making Request"
    # Use HttpWebRequest instead of Invoke-WebRequest, because the latter doesn't support arrays in POST params.
    $req = [System.Net.HttpWebRequest]::Create($apiURI);
    $req.Method = "POST";
    $req.ContentLength = $params.Length;
    $req.ContentType = "application/x-www-form-urlencoded";
    foreach($key in $headers.Keys)
    {
        $req.Headers.Add($key, $headers[$key]); 
    }

    Write-Log "Fireing off Request"
    $str = $req.GetRequestStream();
    $str.Write($b, 0, $b.Length);
    $str.Close();
    $str.Dispose();

    Write-Log "Fetching Response"
    $res = $req.GetResponse();
    $str = $res.GetResponseStream();
    $rdr = New-Object -TypeName "System.IO.StreamReader" -ArgumentList ($str);
    $content = $rdr.ReadToEnd();
    $str.Close();
    $str.Dispose();
    $rdr.Dispose();

    Write-Log "Building Response Object to Return"
    # Build a return object that's similar to a Microsoft.PowerShell.Commands.HtmlWebResponseObject
    $ret = New-Object -TypeName "System.Object";
    $ret | Add-Member -Type NoteProperty -Name "BaseResponse" -Value $res;
    $ret | Add-Member -Type NoteProperty -Name "Content" -Value $content;
    $ret | Add-Member -Type NoteProperty -Name "StatusCode" -Value ([int] $res.StatusCode);
    $ret | Add-Member -Type NoteProperty -Name "StatusDescription" -Value $res.StatusDescription;
    return $ret;
}