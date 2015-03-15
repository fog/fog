if ENV["COVERAGE"]
  require "simplecov"

  SimpleCov.start do
    add_filter "/spec/"
  end
end

require "minitest/autorun"
require "minitest/spec"
require "minitest/stub_const"

$LOAD_PATH.unshift "lib"

require "fog"
