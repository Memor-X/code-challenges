class ListNode
    attr_accessor :val, :next
    def initialize(val = 0, _next = nil)
        @val = val
        @next = _next
    end
end

def new_ListNode_obj(listArr)
    newListNode = ListNode.new(0)

    currNode = newListNode
    i = 0
    while i < listArr.length do
        currNode.val = listArr[i]
        if(i+1 != listArr.length)
            currNode.next = ListNode.new(0)
            currNode = currNode.next
        end

        i += 1
    end

    return newListNode
end

def get_ListNode_length(listNodeObj)
    length = 0

    currNode = listNodeObj
    while currNode != nil do
        length += 1
        currNode = currNode.next
    end

    return length
end