require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe ProfitBricks do
  include Fog::BinSpec

  let(:subject) { ProfitBricks }
end
