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
def find_median_sorted_arrays(nums1, nums2)
    combinedArr = (nums1 + nums2).sort
    Log.debug("combinedArr = "+combinedArr.join(', '))

    midMod = combinedArr.length % 2
    mid = ((combinedArr.length - midMod) / 2)-1
    midArr = if midMod == 0 then [combinedArr[mid].to_f,combinedArr[mid+1].to_f] else [combinedArr[mid+1].to_f,combinedArr[mid+1].to_f] end
    Log.debug("midArr = "+midArr.join(', '))

    medium = (midArr[0] + midArr[1]) / 2

    return medium
end