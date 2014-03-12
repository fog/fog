require "minitest/autorun"
require "fog/brightbox"

class Fog::Compute::BrightboxTest < Minitest::Test
  def setup
    @arguments = {}
    @service = Fog::Compute::Brightbox.new(@arguments)
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
