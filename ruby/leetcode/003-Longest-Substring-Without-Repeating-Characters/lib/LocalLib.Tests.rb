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

    describe "length_of_longest_substring" do
        describe "LeetCode Tests" do
            it "Case 1" do
                testVal = 'abcabcbb'
                expected = 3

                result = length_of_longest_substring(testVal)
                _(result).must_equal expected
            end

            it "Case 2" do
                testVal = 'bbbbb'
                expected = 1

                result = length_of_longest_substring(testVal)
                _(result).must_equal expected
            end

            it "Case 3" do
                testVal = 'pwwkew'
                expected = 3

                result = length_of_longest_substring(testVal)
                _(result).must_equal expected
            end

            it "Case 4" do
                testVal = 'bwf'
                expected = 3

                result = length_of_longest_substring(testVal)
                _(result).must_equal expected
            end

            it "Case 5" do
                testVal = 'dvdf'
                expected = 3

                result = length_of_longest_substring(testVal)
                _(result).must_equal expected
            end
        end
    end

end
