require 'rubygems'
require 'base64'
require 'cgi'
require 'curb'
require 'hmac-sha1'

require File.dirname(__FILE__) + '/s3/parsers'

module Fog
  module AWS
    class S3

      # Initialize connection to S3
      #
      # ==== Notes
      # options parameter must include values for :aws_access_key_id and 
      # :aws_secret_access_key in order to create a connection
      #
      # ==== Examples
      # sdb = S3.new(
      #  :aws_access_key_id => your_aws_access_key_id,
      #  :aws_secret_access_key => your_aws_secret_access_key
      # )
      #
      # ==== Parameters
      # options<~Hash>:: config arguments for connection.  Defaults to {}.
      #
      # ==== Returns
      # S3 object with connection to aws.
      def initialize(options={})
        @aws_access_key_id      = options[:aws_access_key_id]
        @aws_secret_access_key  = options[:aws_secret_access_key]
        @hmac       = HMAC::SHA1.new(@aws_secret_access_key)
        @host       = options[:host]      || 's3.amazonaws.com'
        @port       = options[:port]      || 443
        @scheme     = options[:scheme]    || 'https'
        @connection = Curl::Easy.new("#{@scheme}://#{@host}:#{@port}")
      end

      def get_service
        request(:get, "#{@scheme}://#{@host}:#{@port}", Fog::Parsers::AWS::S3::GetServiceParser.new)
      end

      def put_bucket(name)
        request(:put, "#{@scheme}://#{name}.#{@host}:#{@port}", Fog::Parsers::AWS::S3::BasicParser.new)
      end

      private

      def request(method, url, parser, data=nil)
        @connection.headers['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")
        params = [
          method.to_s.upcase,
          content_md5 = '',
          content_type = '',
          @connection.headers['Date'],
          canonicalized_amz_headers = nil,
          canonicalized_resource = '/'
        ]
        string_to_sign = params.delete_if {|value| value.nil?}.join("\n")
        hmac = @hmac.update(string_to_sign)
        signature = Base64.encode64(hmac.digest).strip

        @connection.url = url
        @connection.headers['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"
        case method
        when :get
          p @connection.url
          @connection.http_get
        when :put
          @connection.http_put(data)
        end
        p @connection.headers
        p @connection.body_str
        Nokogiri::XML::SAX::Parser.new(parser).parse(@connection.body_str)
        parser.result
      end
   
    end
  end
end