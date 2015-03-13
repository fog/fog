require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe PowerDNS do
  include Fog::BinSpec
  let(:subject) { PowerDNS }
end