require 'rubygems'
require 'base64'
require 'cgi'
require 'hmac-sha1'
require 'uri'

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
      end

      def get_service
        request('GET', "#{@scheme}://#{@host}:#{@port}/", Fog::Parsers::AWS::S3::GetServiceParser.new)
      end

      def put_bucket(name)
        request('PUT', "#{@scheme}://#{name}.#{@host}:#{@port}/", Fog::Parsers::AWS::S3::BasicParser.new)
      end
      
      def delete_bucket(name)
        request('DELETE', "#{@scheme}://#{name}.#{@host}:#{@port}/", Fog::Parsers::AWS::S3::BasicParser.new)
      end

      private

      def request(method, url, parser, data=nil)
        uri = URI.parse(url)
        headers = { 'Date' => Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000") }
        params = [
          method,
          content_md5 = '',
          content_type = '',
          headers['Date'],
          canonicalized_amz_headers = nil,
          canonicalized_resource = "/#{'s3.amazonaws.com' == uri.host ? "" : "#{uri.host.split('.s3.amazonaws.com')[0]}/"}"
        ]
        string_to_sign = params.delete_if {|value| value.nil?}.join("\n")
        hmac = @hmac.update(string_to_sign)
        signature = Base64.encode64(hmac.digest).strip
        headers['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"
        
        response = nil
        EventMachine::run {
          http = EventMachine.connect(@host, @port, Fog::AWS::Connection) {|connection|
            connection.headers = headers
            connection.method = method
            connection.parser = parser
            connection.url = url
          }
          http.callback {|http| response = http.response}
        }
        response
      end
   
    end
  end
end