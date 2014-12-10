require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Vmfusion do
  include Fog::BinSpec

  let(:subject) { Vmfusion }
end
