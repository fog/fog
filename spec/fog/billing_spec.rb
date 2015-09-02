require "spec_helper"

describe Fog::Billing do
  Fog::Billing.providers.each do |provider|
    describe "when #{provider} is passed with no available credentials" do
      it "returns ArgumentError" do
        # Stub credentials so you still see errors where the tester really has credentials
        Fog.stub :credentials, {} do
          assert_raises(ArgumentError) { Fog::Billing[provider] }
        end
      end
    end
  end
end
