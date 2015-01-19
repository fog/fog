require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Ovirt do
  include Fog::BinSpec

  let(:subject) { Ovirt }
end
