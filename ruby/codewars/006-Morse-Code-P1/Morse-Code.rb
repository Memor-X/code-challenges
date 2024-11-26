########################################
#
# File Name:	Morse-Code.rb
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

morseCode = '.... . -.--   .--- ..- -.. .'
translation = decodeMorse(morseCode)
Log.log(translation)

Log.end()
