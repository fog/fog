require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe StormOnDemand do
  include Fog::BinSpec

  let(:subject) { StormOnDemand }
end
