require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Softlayer do
  include Fog::BinSpec

  let(:subject) { Softlayer }
end
