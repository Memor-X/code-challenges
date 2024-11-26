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

    describe "find_median_sorted_arrays" do
        describe "LeetCode Tests" do
            it "Case 1" do
                testVal1 = [1,3]
                testVal2 = [2]
                expected = 2.00000

                result = find_median_sorted_arrays(testVal1,testVal2)
                _(result).must_equal expected
            end

            it "Case 2" do
                testVal1 = [1,2]
                testVal2 = [3,4]
                expected = 2.50000

                result = find_median_sorted_arrays(testVal1,testVal2)
                _(result).must_equal expected
            end
        end
    end

end
