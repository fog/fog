require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe RiakCS do
  include Fog::BinSpec

  let(:subject) { RiakCS }
end
