require "spec_helper"

describe Fog::DNS do
  Fog::DNS.providers.each do |provider|
    describe "when #{provider} is passed with no available credentials" do
      it "returns ArgumentError" do
        # Stub credentials so you still see errors where the tester really has credentials
        Fog.stub :credentials, {} do
          # These providers do not raise ArgumentError since they have no requirements defined
          if [:dnsimple].include?(provider)
            assert Fog::DNS[provider]
          else
            assert_raises(ArgumentError) { Fog::DNS[provider] }
          end
        end
      end
    end
  end
end
