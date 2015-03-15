require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Dreamhost do
  include Fog::BinSpec

  let(:subject) { Dreamhost }
end
