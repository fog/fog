require "spec_helper"

describe Fog::Volume do
  Fog::Volume.providers.each do |provider|
    describe "when #{provider} is passed with no available credentials" do
      it "returns ArgumentError" do
        # Stub credentials so you still see errors where the tester really has credentials
        Fog.stub :credentials, {} do
          assert_raises(ArgumentError) { Fog::Volume[provider] }
        end
      end
    end
  end
end
