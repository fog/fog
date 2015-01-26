require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Voxel do
  include Fog::BinSpec

  let(:subject) { Voxel }
end
