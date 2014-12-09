require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Openvz do
  include Fog::BinSpec

  let(:subject) { Openvz }
end
