$stdout.sync
$stdin.sync
$stderr.sync
require 'bundler/setup'
Bundler.require(:development, :bdd, :cukes) if defined?(Bundler)
require 'tmpdir'
require 'cucumber/rspec/doubles'

require File.dirname(__FILE__) + "/../../lib/fog"
require File.dirname(__FILE__) + "/../../lib/fog/core/bdd"
