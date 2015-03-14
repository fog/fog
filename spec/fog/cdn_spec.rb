require "spec_helper"

describe Fog::CDN do
  Fog::CDN.providers.each do |provider|
    describe "when #{provider} is passed with no available credentials" do
      it "returns ArgumentError" do
        # Stub credentials so you still see errors where the tester really has credentials
        Fog.stub :credentials, {} do
          assert_raises(ArgumentError) { Fog::CDN[provider] }
        end
      end
    end
  end
end
