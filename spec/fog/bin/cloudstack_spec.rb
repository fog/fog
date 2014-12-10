require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Cloudstack do
  include Fog::BinSpec

  let(:subject) { Cloudstack }
end
