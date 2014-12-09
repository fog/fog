require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe IBM do
  include Fog::BinSpec

  let(:subject) { IBM }
end
