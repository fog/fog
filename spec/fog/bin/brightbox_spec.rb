require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Brightbox do
  include Fog::BinSpec

  let(:subject) { Brightbox }
end
