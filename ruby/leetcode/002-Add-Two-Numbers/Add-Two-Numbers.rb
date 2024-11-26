########################################
#
# File Name:	Add-Two-Numbers.rb
# Date Created:	11/11/2024
# Description:	
#	
#
########################################

# File Imports
require_relative 'lib/LocalLib.rb'

#=======================================

# Global Variables

#=======================================

Log.start()

list1 = [2,4,3]
list1Obj = new_ListNode_obj(list1)
Log.log("list 1 = "+list1.join(', '))



list2 = [5,6,4]
list2Obj = new_ListNode_obj(list2)
Log.log("list 2 = "+list2.join(', '))

answer = add_two_numbers(list1Obj,list2Obj)
expectedAnswer = [7,0,8]
Log.log("Add Two Numbers Expected Answer = "+expectedAnswer.join(', '))

Log.log("Answer Parts")
Log.log("Part 1 = "+answer.val.to_s)
Log.log("Part 2 = "+answer.next.val.to_s)
Log.log("Part 3 = "+answer.next.next.val.to_s)

expectedAnswer = [answer.val, answer.next.val, answer.next.next.val]
Log.log("Add Two Numbers Actual Answer = "+expectedAnswer.join(', '))



Log.end()
