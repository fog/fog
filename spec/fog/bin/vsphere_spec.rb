require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Vsphere do
  include Fog::BinSpec

  let(:subject) { Vsphere }
end
