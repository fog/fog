require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe DNSMadeEasy do
  include Fog::BinSpec

  let(:subject) { DNSMadeEasy }
end
