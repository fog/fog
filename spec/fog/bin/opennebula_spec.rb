require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe OpenNebula do
  include Fog::BinSpec

  let(:subject) { OpenNebula }
end
