require "minitest/autorun"
require "fog/brightbox"

describe Fog::Compute::Brightbox do
  describe "when global config is available" do
    before do
      @arguments = {
        :brightbox_auth_url => "http://localhost",
        :brightbox_api_url => "http://localhost",
        :brightbox_client_id => "",
        :brightbox_secret => "",
        :brightbox_username => "",
        :brightbox_password => "",
        :brightbox_account => ""
      }

      @credential_guard = Minitest::Mock.new
      def @credential_guard.reject
        {}
      end

      Fog.stub :credentials, @credential_guard do
        @service = Fog::Compute::Brightbox.new(@arguments)
      end
    end

    it "responds to #request" do
      assert_respond_to @service, :request
    end

    it "responds to #request_access_token" do
      assert_respond_to @service, :request_access_token
    end

    it "responds to #wrapped_request" do
      assert_respond_to @service, :wrapped_request
    end
  end

  describe "when created without required arguments" do
    it "raises an error" do
      Fog.stub :credentials, {} do
        assert_raises ArgumentError do
          Fog::Compute::Brightbox.new({})
        end
      end
    end
  end
end
