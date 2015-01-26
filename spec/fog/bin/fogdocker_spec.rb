require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Fogdocker do
  include Fog::BinSpec

  let(:subject) { Fogdocker }
end
