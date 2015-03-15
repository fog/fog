require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe DNSimple do
  include Fog::BinSpec

  let(:subject) { DNSimple }
end
