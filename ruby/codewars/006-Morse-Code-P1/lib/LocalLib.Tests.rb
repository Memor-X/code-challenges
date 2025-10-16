# loading Unit Test
require 'minitest/hooks'
require "minitest/autorun"
require "minitest"

# Loading LocalLib Library
require_relative 'LocalLib.rb'

# Setting up sys.stdout.write mock and output buffer
$outputBuffer = {}
$outputBuffer["screen"] = []

def print(str)
    $outputBuffer["screen"].append(str)
end

class ExtendedMinitest < Minitest::Test
    extend Minitest::Spec::DSL
    include Minitest::Hooks # You need to add this to your test classes
end

# Tests
class MyTest < ExtendedMinitest

    def setup
        #File.open(file)
        @original_time_now = Time.method(:now) # Store the original method
        Time.define_singleton_method(:now) { Time.new(2000, 1, 1, 11, 10, 0, "+10:00") } # Redefine now
    end

    def teardown
        Time.define_singleton_method(:now, @original_time_now) # Restore the original method
    end

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
    
end