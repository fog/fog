require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Cloudstack do
  include Fog::BinSpec

  let(:subject) { Cloudstack }
end
