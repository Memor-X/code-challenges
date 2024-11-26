########################################
#
# File Name:	Median-Of-Two-Sorted-Arrays.rb
# Date Created:	18/11/2024
# Description:	
#	
#
########################################

# File Imports
require_relative 'lib/LocalLib.rb'

#=======================================

# Global Variables

#=======================================

Log.start()

nums1 = [1,2]
Log.log("nums1 = "+nums1.join(', '))

nums2 = [3,4]
Log.log("nums2 = "+nums2.join(', '))

expect = 2.50000
actual = find_median_sorted_arrays(nums1,nums2)
Log.log("expected answer = " + expect.to_s)
Log.log("actual answer = " + actual.to_s)

Log.end()
