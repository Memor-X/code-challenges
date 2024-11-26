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
    describe "count_bits" do

        describe "Codewars Tests" do
            describe "Fixed tests" do
                it "should pass Fixed Test 1" do
                    _(count_bits(0)).must_equal 0
                end

                it "should pass Fixed Test 2" do
                    _(count_bits(4)).must_equal 1
                end

                it "should pass Fixed Test 3" do
                    _(count_bits(7)).must_equal 3
                end

                it "should pass Fixed Test 4" do
                    _(count_bits(9)).must_equal 2
                end

                it "should pass Fixed Test 5" do
                    _(count_bits(10)).must_equal 2
                end
            end
        end

    end
end