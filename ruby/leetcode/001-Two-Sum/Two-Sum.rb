########################################
#
# File Name:	Two-Sum.rb
# Date Created:	11/11/2024
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

nums = [11,7,15,2]
Log.log("nums = "+nums.join(', '))

target = 9
Log.log("target = "+target.to_s)

twoSum = two_sum(nums,target)
Log.log("Two Sum Answer = "+twoSum.join(', '))

Log.end()
