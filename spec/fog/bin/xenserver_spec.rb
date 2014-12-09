require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe XenServer do
  include Fog::BinSpec

  let(:subject) { XenServer }
end
