require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe BareMetalCloud do
  include Fog::BinSpec

  let(:subject) { BareMetalCloud }
end
