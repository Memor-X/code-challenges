########################################
#
# File Name:	LocalLib.ps1
# Date Created:	11/11/2024
# Description:	
#	Local Functions for Unit Testing
#
########################################

# File Imports
require_relative '../../../lib/Common.rb'
require_relative 'ListNode.class.rb'

#=======================================

# Global Variables

#=======================================
def add_two_numbers(l1, l2)
    answer = ListNode.new(0)
    maxDigits = get_ListNode_length(l1)
    l2Length = get_ListNode_length(l2)
    if maxDigits < l2Length
        maxDigits = l2Length
    end

    i = 0
    carryover = 0

    l1CurObj = l1
    l2CurObj = l2
    answerCurObj = answer
    while i <= maxDigits-1 do
        l1Val = if l1CurObj != nil then l1CurObj.val else 0 end
        l2Val = if l2CurObj != nil then l2CurObj.val else 0 end
        #Log.debug("l1["+i.to_s+"] = "+l1Val.to_s+" | l2["+i.to_s+"] = "+l2Val.to_s+" | carryover = "+carryover.to_s)
        
        sum = l1Val + l2Val + carryover
        ones = sum % 10
        tens = 0
        if sum > 9
            tens = (sum - ones)/10
        end
        #Log.debug("sum = "+sum.to_s+" | ones = "+ones.to_s+" | tens = "+tens.to_s)
        answerCurObj.val = ones
        carryover = tens

        l1CurObj = if l1CurObj != nil then l1CurObj.next else nil end
        l2CurObj = if l2CurObj != nil then l2CurObj.next else nil end

        i += 1

        if i <= maxDigits-1
            answerCurObj.next = ListNode.new(0)
            answerCurObj = answerCurObj.next
        end

        #Log.debug("---------------------------")
    end

    if carryover > 0
        answerCurObj.next = ListNode.new(carryover)
    end
    
    return answer
end

def zero_nil_index(arr,index)
    if arr[index] == nil
        return 0
    else
        return arr[index]
    end
end