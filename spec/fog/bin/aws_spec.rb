require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe AWS do
  include Fog::BinSpec

  let(:subject) { AWS }
end
