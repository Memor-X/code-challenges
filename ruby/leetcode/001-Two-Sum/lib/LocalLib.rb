########################################
#
# File Name:	LocalLib.ps1
# Date Created:	11/11/2024
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
require_relative '../../../lib/Common.rb'

#=======================================

# Global Variables

#=======================================

def two_sum(nums, target)
    answer = [0,0]

    i = 0
    while i <= nums.length-2 do
        j = i+1
        while j <= nums.length-1 do
            #Log.log("i = " + i.to_s + " | j = " + j.to_s + " | sum: " + nums[i].to_s + " + " + nums[j].to_s + " = " + (nums[i] + nums[j]).to_s)
            if (nums[i] + nums[j]) == target
                answer[0] = i
                answer[1] = j

                i = nums.length + 1
                j = nums.length + 1
            end

            j += 1
        end

        i += 1
    end

    return answer
end