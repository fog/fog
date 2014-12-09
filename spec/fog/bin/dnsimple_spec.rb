require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe DNSimple do
  include Fog::BinSpec

  let(:subject) { DNSimple }
end
