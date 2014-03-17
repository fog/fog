require "minitest/autorun"
require "fog"

# Note this is going to be part of fog-xml eventually
class Fog::XML::ConnectionTest < Minitest::Test
  def setup
    @connection = Fog::XML::Connection.new("http://localhost")
  end

  def teardown
    Excon.stubs.clear
  end

  def test_respond_to_request
    assert_respond_to @connection, :request
  end

  def test_request_with_parser
    @parser = Fog::ToHashDocument.new
    Excon.stub({}, { :status => 200, :body => "<xml></xml>" })
    response = @connection.request(:parser => @parser, :mock => true)
    assert_equal({ :xml => "" }, response.body)
  end

  def test_request_without_parser
    Excon.stub({}, { :status => 200, :body => "<xml></xml>" })
    response = @connection.request(:mock => true)
    assert_equal("<xml></xml>", response.body)
  end
end
