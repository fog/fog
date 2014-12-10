require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Rage4 do
  include Fog::BinSpec

  let(:subject) { Rage4 }
end
