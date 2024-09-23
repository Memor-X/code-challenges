########################################
#
# File Name:	LocalLib.ps1
# Date Created:	29/08/2024
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
require_relative '../../../lib/Common.rb'

#=======================================

# Global Variables

#=======================================
def count_bits(n)
    bitVal = n.to_s(2)
    bitStr = bitVal.gsub "0", ""
    return bitStr.length
end
