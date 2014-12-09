require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Linode do
  include Fog::BinSpec

  let(:subject) { Linode }
end
