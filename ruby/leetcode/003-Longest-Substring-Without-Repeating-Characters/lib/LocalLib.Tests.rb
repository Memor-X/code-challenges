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

end