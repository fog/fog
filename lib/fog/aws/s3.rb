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

      # List information about S3 buckets for authorized user
      def get_service
        request(
          'GET',
          "#{@scheme}://#{@host}:#{@port}/",
          Fog::Parsers::AWS::S3::GetServiceParser.new
        )
      end

      # Create an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to create
      def put_bucket(bucket_name)
        request(
          'PUT',
          "#{@scheme}://#{bucket_name}.#{@host}:#{@port}/",
          Fog::Parsers::AWS::S3::BasicParser.new
        )
      end

      # List information about objects in an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to list object keys from
      # options<~Hash>:: config arguments for list.  Defaults to {}.
      #   :prefix limits object keys to those beginning with its value.
      #   :marker limits object keys to only those that appear
      #     lexicographically after its value.
      #   :maxkeys limits number of object keys returned
      #   :delimiter causes keys with the same string between the prefix
      #     value and the first occurence of delimiter to be rolled up
      def get_bucket(bucket_name, options = {})
        options['max-keys'] = options.delete(:maxkeys) if options[:maxkeys]
        params.delete_if {}
        query = '?'
        options.each do |key, value|
          query << "#{key}=#{value};"
        end
        query.chop!
        request(
          'GET',
          "#{@scheme}://#{bucket_name}.#{@host}:#{@port}/#{query}",
          Fog::Parsers::AWS::S3::GetBucketParser.new
        )
      end

      # Delete an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to delete
      def delete_bucket(bucket_name)
        request(
          'DELETE',
          "#{@scheme}://#{bucket_name}.#{@host}:#{@port}/",
          Fog::Parsers::AWS::S3::BasicParser.new
        )
      end

      private

      def request(method, url, parser, data = nil)
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