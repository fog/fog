require "minitest/autorun"
require "fog/brightbox"

class Fog::Compute::BrightboxTest < Minitest::Test
  def setup
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

  def test_respond_to_request
    assert_respond_to @service, :request
  end

  def test_respond_to_request_access_token
    assert_respond_to @service, :request_access_token
  end

  def test_respond_to_wrapped_request
    assert_respond_to @service, :wrapped_request
  end
end
