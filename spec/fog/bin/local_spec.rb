require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Local do
  include Fog::BinSpec

  let(:subject) { Local }
end
