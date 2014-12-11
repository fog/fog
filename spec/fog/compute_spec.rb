require "minitest/autorun"
require "fog"

describe Fog::Compute do
  it "responds to []" do
    assert_respond_to Fog::Compute, :[]
  end
end
