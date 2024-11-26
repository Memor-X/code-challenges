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
require_relative 'MorseCodeDic.rb'

#=======================================

# Global Variables

#=======================================

def decodeMorse(morseCode)
    #print('Codewars Test Input = |'+morseCode)
    translate = ''
    code = morseCode.strip.gsub '   ', ' S '
    morseChars = code.split(' ')

    morseChars.each do |char|
        if char == 'S'
            translate += ' '
        else
            translate += MORSE_CODE[char]
        end
    end

    return translate
end