require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe Google do
  include Fog::BinSpec

  let(:subject) { Google }
end
