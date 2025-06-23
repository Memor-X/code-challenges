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

    describe "zero_nil_index" do
        it "return value at sopecifies index" do
            testValArg1 = [2,7,11,15]
            testValArg2 = 2
            expected = 11
            _(zero_nil_index(testValArg1,testValArg2)).must_equal expected
        end

        it "return 0 at non existing index" do
            testValArg1 = [2,7,11,15]
            testValArg2 = 7
            expected = 0
            _(zero_nil_index(testValArg1,testValArg2)).must_equal expected
        end

    end

    describe "add_two_numbers" do

        describe "LeetCode Tests" do
            it "Case 1" do
                testValArg1 = new_ListNode_obj([2,4,3])
                testValArg2 = new_ListNode_obj([5,6,4])
                expected = [7,0,8]

                answerObj = add_two_numbers(testValArg1,testValArg2)
                answerArr = [answerObj.val, answerObj.next.val, answerObj.next.next.val]
                _(answerArr).must_equal expected
            end
            it "Case 2" do
                testValArg1 = new_ListNode_obj([0])
                testValArg2 = new_ListNode_obj([0])
                expected = [0]

                answerObj = add_two_numbers(testValArg1,testValArg2)
                answerArr = [answerObj.val]
                _(answerArr).must_equal expected
            end
            it "Case 3" do
                testValArg1 = new_ListNode_obj([9,9,9,9,9,9,9])
                testValArg2 = new_ListNode_obj([9,9,9,9])
                expected = [8,9,9,9,0,0,0,1]
                
                answerObj = add_two_numbers(testValArg1,testValArg2)
                answerArr = [answerObj.val, 
                    answerObj.next.val, 
                    answerObj.next.next.val,
                    answerObj.next.next.next.val,
                    answerObj.next.next.next.next.val,
                    answerObj.next.next.next.next.next.val,
                    answerObj.next.next.next.next.next.next.val,
                    answerObj.next.next.next.next.next.next.next.val]
                _(answerArr).must_equal expected
            end
            it "Case 3 Reversed" do
                testValArg2 = new_ListNode_obj([9,9,9,9,9,9,9])
                testValArg1 = new_ListNode_obj([9,9,9,9])
                expected = [8,9,9,9,0,0,0,1]
                
                answerObj = add_two_numbers(testValArg1,testValArg2)
                answerArr = [answerObj.val, 
                    answerObj.next.val, 
                    answerObj.next.next.val,
                    answerObj.next.next.next.val,
                    answerObj.next.next.next.next.val,
                    answerObj.next.next.next.next.next.val,
                    answerObj.next.next.next.next.next.next.val,
                    answerObj.next.next.next.next.next.next.next.val]
                _(answerArr).must_equal expected
            end
        end

    end

end
