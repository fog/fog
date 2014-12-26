require "minitest/autorun"
require "fog"

describe Fog::Support do
  Fog::Support.providers.each do |provider|
    describe "when #{provider} is passed with no available credentials" do
      it "returns ArgumentError" do
        # Stub credentials so you still see errors where the tester really has credentials
        Fog.stub :credentials, {} do
          assert_raises(ArgumentError) { Fog::Support[provider] }
        end
      end
    end
  end
end
