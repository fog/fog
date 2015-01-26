require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe SakuraCloud do
  include Fog::BinSpec

  let(:subject) { SakuraCloud }
end
