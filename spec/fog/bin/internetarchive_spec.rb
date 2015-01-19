require "minitest/autorun"
require "fog"
require "fog/bin"
require "helpers/bin"

describe InternetArchive do
  include Fog::BinSpec

  let(:subject) { InternetArchive }
end
