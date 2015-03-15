require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe DigitalOcean do
  include Fog::BinSpec

  let(:subject) { DigitalOcean }
end
