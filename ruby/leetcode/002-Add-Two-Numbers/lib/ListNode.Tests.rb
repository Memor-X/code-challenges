# loading Unit Test
require "minitest/autorun"

# Loading LocalLib Library
require_relative 'ListNode.class.rb'

# Setting up sys.stdout.write mock and output buffer
$outputBuffer = {}
$outputBuffer["screen"] = []
def print(str)
    $outputBuffer["screen"].append(str)
end

# Tests
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
