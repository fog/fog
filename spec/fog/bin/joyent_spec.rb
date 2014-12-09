require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Joyent do
  include Fog::BinSpec

  let(:subject) { Joyent }
end
