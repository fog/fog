require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Clodo do
  include Fog::BinSpec

  let(:subject) { Clodo }
end
