########################################
#
# File Name:	LocalLib.ps1
# Date Created:	18/11/2024
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
require_relative '../../../lib/Common.rb'

#=======================================

# Global Variables

#=======================================
def length_of_longest_substring(s)
    possibleLargest = s.chars.to_a.uniq.length
    if possibleLargest <= 2 || possibleLargest == s.length
        return possibleLargest
    end

    i = 0
    genSubStr = s[i]
    largestStr = ''
    j = 1
    term = 'o'
    while term == 'o' do
        genSubStr += s[j]
        Log.log("i = "+i.to_s+" | j = "+j.to_s+" | "+genSubStr)

        if genSubStr.chars.to_a.uniq.length != genSubStr.length
            largestStr = if genSubStr.length-1 > largestStr.length then genSubStr[0...genSubStr.length-1] else largestStr end
            Log.log('LargestString = '+largestStr)
            i += 1
            genSubStr = s[i]
            j = i
        end
        
        j += 1
        if j >= s.length || largestStr.length == possibleLargest
            term = 'x'
            largestStr = if genSubStr.length > largestStr.length then genSubStr else largestStr end
            Log.log('LargestString (Loop Termination) = '+largestStr)
        end
    end

    return largestStr.length
end