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
    
end