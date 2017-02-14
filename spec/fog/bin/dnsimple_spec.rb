require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe Dnsimple do
  include Fog::BinSpec

  let(:subject) { Dnsimple }
end
