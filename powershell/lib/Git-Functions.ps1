########################################
#
# File Name:	Git-Functions.ps1
# Date Created:	18/01/2023
# Description:
#	Function library for git specific functions
#
########################################

# file imports
. "$($PSScriptRoot)\Common.ps1"
. "$($PSScriptRoot)\XML.ps1"

########################################
#
# Name:		Gen-Repo-List
# Input:	$xml <XML Object>
# Output:	$collectedRepoList <Hash Object>
# Description:
#	returns a Hash Object with a collection of git repos, their directory locations
#   and if they are they main branch or not. all sourced from the git-settings.xml
#
########################################
function Gen-Repo-List($xml)
{
    # gets the repo list from the xml file
    $repos = Fetch-XMLVal $xml "settings.repos"
    $collectedRepoList = @()

    # checks if we have only the 1 <repo> node or an array of them
    if ($repos.repo.GetType().BaseType.Name -eq "XmlLinkedNode")
    {
        $collectedRepoList += @(
            @{"name" = $repos.repo.'#text'
                "location" = $repos.repo.location
                "main" = $repos.repo.main
            })
    }
    else
    {
        # if an array of nodes, loops though them
        foreach ($singleRepo in $repos.repo)
        {
            $collectedRepoList += @(@{"name" = $singleRepo.'#text'
                    "location" = $singleRepo.location
                    "main" = $singleRepo.main
                })
        }
    }
    return $collectedRepoList
}

########################################
#
# Name:		Find-Repo
# Input:	$repoName <String>
#			$repoCol <Array Hash Object>
# Output:	$returnObj <Hash Object>
# Description:
#	looks through the Array of Hash Objects created by Gen-Repo-List and returns the
#   has object who's name matches what is passed by $repoName. otherwise returns an empty
#   hash object with found still being false
#
########################################
function Find-Repo($repoName, $repoCol)
{
    $returnObj = @{
        name = ""
        location = ""
        main = ""
        found = $false
    }

    foreach ($singleRepo in $repoCol)
    {
        Write-Debug $singleRepo.name
        if ($singleRepo.name -eq $repoName)
        {
            $returnObj.name = $singleRepo.name
            $returnObj.location = "$($singleRepo.location)\$($singleRepo.name)"
            $returnObj.main = $singleRepo.main
            $returnObj.found = $true

            return $returnObj
        }
    }
    return $returnObj
}

########################################
#
# Name:		Get-Commits
# Input:	$filters <Array>
# Output:	$returnObj <Hash Object>
# Description:
#	returns a formatted hash object of commits
#
########################################
function Get-Commits($filters, $path = "")
{
    $commit_entry = @{
        "commitID" = "";
        "author" = "";
        "time" = "";
        "comment" = ""
    }
    $commit_obj = @()
    $filter_str = $filters -join " "
    $commits = Run-Command "git log ${filter_str} --pretty=format:`"%H<>%an<>%at<>%s`" $($path)"

    foreach ($commit in $commits)
    {
        $commit_line = $commit_entry.Clone() # ensures that $commit_line is blank
        $commit_split = $commit -Split ("<>")

        $commit_line.commitID = $commit_split[0].Trim()
        $commit_line.author = $commit_split[1].Trim()
        $commit_line.time = (String-To-Int $commit_split[2].Trim())
        $commit_line.comment = $commit_split[3].Trim()

        $commit_obj += $commit_line
    }

    return $commit_obj
}