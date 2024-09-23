require "minitest/autorun"
require_relative 'Common.rb'

describe "Common" do
  
    before do
        #print "set up function"
    end

    describe "get_version" do
        it "should return 1, 2 and 3" do
            version = Common.get_version("1.2.3")
            _(version["major"]).must_equal "1"
            _(version["minor"]).must_equal "2"
            _(version["bug"]).must_equal "3"
        end
    end

end