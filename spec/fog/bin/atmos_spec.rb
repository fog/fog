require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Atmos do
  include Fog::BinSpec

  let(:subject) { Atmos }
end
