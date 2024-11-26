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
    
    describe "two_sum" do
        describe "LeetCode Tests" do
            it "Case 1" do
                testValArg1 = [2,7,11,15]
                testValArg2 = 9
                expected = [0,1]
                _(two_sum(testValArg1,testValArg2)).must_equal expected
            end
            it "Case 2" do
                testValArg1 = [3,2,4]
                testValArg2 = 6
                expected = [1,2]
                _(two_sum(testValArg1,testValArg2)).must_equal expected
            end
            it "Case 3" do
                testValArg1 = [3,3]
                testValArg2 = 6
                expected = [0,1]
                _(two_sum(testValArg1,testValArg2)).must_equal expected
            end
        end

    end
end
