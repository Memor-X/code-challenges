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

end