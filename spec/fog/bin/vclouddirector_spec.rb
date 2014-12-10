require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe VcloudDirector do
  include Fog::BinSpec

  let(:subject) { VcloudDirector }
end
