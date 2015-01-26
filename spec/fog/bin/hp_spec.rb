require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe HP do
  include Fog::BinSpec

  let(:subject) { HP }
end
