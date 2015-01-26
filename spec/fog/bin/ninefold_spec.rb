require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Ninefold do
  include Fog::BinSpec

  let(:subject) { Ninefold }
end
