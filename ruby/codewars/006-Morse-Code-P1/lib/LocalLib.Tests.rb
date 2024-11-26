# loading Unit Test
require "minitest/autorun"

# Loading LocalLib Library
require_relative 'LocalLib.rb'

# Setting up sys.stdout.write mock and output buffer
$outputBuffer = {}
$outputBuffer["screen"] = []
def print(str)
    $outputBuffer["screen"].append(str)
end

# Tests
describe "LocalLib" do
    # Clears the output buffer after every test
    before do
        $outputBuffer = {}
        $outputBuffer["screen"] = []
    end
    describe "decodeMorse" do

        describe "Codewars Tests" do
            it "Example from description" do
                _(decodeMorse('.... . -.--   .--- ..- -.. .')).must_equal 'HEY JUDE'
            end
            
            describe "More complex tests" do
                it "E E" do
                    testVal = '   .   . '
                    expected = 'E E'
                    _(decodeMorse(testVal)).must_equal expected
                end

                it "SOS! THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG." do
                    testVal = '      ...---... -.-.--   - .... .   --.- ..- .. -.-. -.-   -... .-. --- .-- -.   ..-. --- -..-   .--- ..- -- .--. ...   --- ...- . .-.   - .... .   .-.. .- --.. -.--   -.. --- --. .-.-.-  '
                    expected = 'SOS! THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG.'
                    _(decodeMorse(testVal)).must_equal expected
                end
            end
        end

        

    end
end
