require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Packet do
  include Fog::BinSpec

  let(:subject) { Packet }
end
