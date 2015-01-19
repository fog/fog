require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe CloudSigma do
  include Fog::BinSpec

  let(:subject) { CloudSigma }
end
