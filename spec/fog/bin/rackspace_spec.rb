require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Rackspace do
  include Fog::BinSpec

  let(:subject) { Rackspace }
end
