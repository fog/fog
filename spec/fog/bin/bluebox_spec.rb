require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Bluebox do
  include Fog::BinSpec

  let(:subject) { Bluebox }
end
