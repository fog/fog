require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Ecloud do
  include Fog::BinSpec

  let(:subject) { Ecloud }
end
