# loading Unit Test
require 'minitest/hooks'
require "minitest/autorun"
require "minitest"

# Loading LocalLib Library
require_relative 'ListNode.class.rb'

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

    describe "ListNode.class" do
        # Clears the output buffer after every test
        before do
            $outputBuffer = {}
            $outputBuffer["screen"] = []
        end

        describe "new_ListNode_obj" do
            it "new ListNode from array [1, 2, 3] first value is 1" do
                testVal = [1,2,3]
                expected = 1

                result = new_ListNode_obj(testVal)
                _(result.val).must_equal expected
            end

            it "new ListNode from array [1, 2, 3] second value is 2" do
                testVal = [1,2,3]
                expected = 2

                result = new_ListNode_obj(testVal)
                _(result.next.val).must_equal expected
            end

            it "new ListNode from array [1, 2, 3] second value is 3" do
                testVal = [1,2,3]
                expected = 3

                result = new_ListNode_obj(testVal)
                _(result.next.next.val).must_equal expected
            end
        end

        describe "get_ListNode_length" do
            it "3 digits ListNode object has a lenght of 3" do
                testVal = new_ListNode_obj([1,2,3])
                expected = 3

                result = get_ListNode_length(testVal)
                _(result).must_equal expected
            end

            it "1 digits ListNode object has a lenght of 1" do
                testVal = new_ListNode_obj([1])
                expected = 1

                result = get_ListNode_length(testVal)
                _(result).must_equal expected
            end

            it "0 value ListNode object has a lenght of 1" do
                testVal = new_ListNode_obj([0])
                expected = 1

                result = get_ListNode_length(testVal)
                _(result).must_equal expected
            end
        end

    end

end