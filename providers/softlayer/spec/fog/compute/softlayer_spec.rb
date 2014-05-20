require "minitest/autorun"
require "fog/softlayer"

describe Fog::Compute::Softlayer do
  describe "when global config is available" do
    before do

      @arguments = {
        :softlayer_api_url => "http://localhost",
        :softlayer_username => "username",
        :softlayer_api_key => "key"
      }

      @credential_guard = Minitest::Mock.new
      def @credential_guard.reject
        {}
      end

      Fog.stub :credentials, @credential_guard do
        @service = Fog::Compute::Softlayer.new(@arguments)
      end
    end

    it "responds to #request" do
      assert_respond_to @service, :request
    end

  end

  describe "when created without required arguments" do
    it "raises an error" do
      Fog.stub :credentials, {} do
        assert_raises ArgumentError do
          Fog::Compute::Softlayer.new({})
        end
      end
    end
  end
end
