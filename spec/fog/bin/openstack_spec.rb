require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe OpenStack do
  include Fog::BinSpec

  let(:subject) { OpenStack }
end
