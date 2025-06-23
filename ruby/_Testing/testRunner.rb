require 'simplecov'

SimpleCov.command_name "test:units"
SimpleCov.coverage_dir SimpleCov.root+'\coverage'
SimpleCov.root 'C:\_Work\_git\script-library\ruby'
SimpleCov.minimum_coverage 90

SimpleCov.add_filter /.*\.suite.rb$/
SimpleCov.add_filter /.*\.Tests.rb$/

SimpleCov.start

require_relative 'test-files.suite.rb'