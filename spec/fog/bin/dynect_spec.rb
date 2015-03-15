require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Dynect do
  include Fog::BinSpec

  let(:subject) { Dynect }
end
