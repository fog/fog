require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Zerigo do
  include Fog::BinSpec

  let(:subject) { Zerigo }
end
