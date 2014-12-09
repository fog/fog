require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Dreamhost do
  include Fog::BinSpec

  let(:subject) { Dreamhost }
end
