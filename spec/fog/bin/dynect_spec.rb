require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Dynect do
  include Fog::BinSpec

  let(:subject) { Dynect }
end
