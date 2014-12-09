require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Libvirt do
  include Fog::BinSpec

  let(:subject) { Libvirt }
end
