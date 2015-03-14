require "spec_helper"

describe Fog::Compute do
  Fog::Compute.providers.each do |provider|
    describe "when #{provider} is passed with no available credentials" do
      it "returns ArgumentError" do
        # Stub credentials so you still see errors where the tester really has credentials
        Fog.stub :credentials, {} do
          # These providers do not raise ArgumentError since they have no requirements defined
          if [:openvz, :vmfusion].include?(provider)
            assert Fog::Compute[provider]
          else
            assert_raises(ArgumentError) { Fog::Compute[provider] }
          end
        end
      end
    end
  end
end
