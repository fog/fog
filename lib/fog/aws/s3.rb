require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'hmac-sha1'
require 'mime/types'
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
          url,
          Fog::Parsers::AWS::S3::GetServiceParser.new
        )
      end

      # Create an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to create
      # options<~Hash>:: config arguments for bucket.  Defaults to {}.
      #   :location_constraint sets the location for the bucket
      def put_bucket(bucket_name, options = {})
        if options[:location_constraint]
          data = <<-DATA
            <CreateBucketConfiguration>
              <LocationConstraint>#{options[:location_constraint]}</LocationConstraint>
            </CreateBucketConfiguration>
          DATA
        else
          data = nil
        end
        request(
          'PUT',
          url(bucket_name),
          Fog::Parsers::AWS::S3::BasicParser.new,
          {},
          data
        )
      end

      # Change who pays for requests to an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to modify
      # payer<~String>:: valid values are BucketOwner or Requester
      def put_request_payment(bucket_name, payer)
        data = <<-DATA
          <RequestPaymentConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
            <Payer>#{payer}</Payer> 
          </RequestPaymentConfiguration>
        DATA
        request(
          'PUT',
          url(bucket_name),
          Fog::Parsers::AWS::S3::BasicParser.new,
          {},
          data
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
        query = '?'
        options.each do |key, value|
          query << "#{key}=#{value};"
        end
        query.chop!
        request(
          'GET',
          url(bucket_name, query),
          Fog::Parsers::AWS::S3::GetBucketParser.new
        )
      end

      # Get configured payer for an S3 bucket
      def get_request_payment(bucket_name)
        request(
          'GET',
          url(bucket_name, '?requestpayment'),
          Fog::Parsers::AWS::S3::GetRequestPayment.new
        )
      end

      # Get location constraint for an S3 bucket
      def get_location(bucket_name)
        request(
          'GET',
          url(bucket_name, '?location'),
          Fog::Parsers::AWS::S3::GetRequestPayment.new
        )
      end

      # Delete an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to delete
      def delete_bucket(bucket_name)
        request(
          'DELETE',
          url(bucket_name),
          Fog::Parsers::AWS::S3::BasicParser.new
        )
      end

      # Create an object in an S3 bucket
      def put_object(bucket_name, object_name, object, options = {})
        file = parse_file(object)
        request(
          'PUT',
          url(bucket_name, object_name),
          Fog::Parsers::AWS::S3::BasicParser.new,
          options.merge!(file[:headers]),
          file[:body]
        )
      end

      # Copy an object from one S3 bucket to another
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name)
        request(
          'PUT',
          url(destination_bucket_name, destination_object_name),
          Fog::Parsers::AWS::S3::BasicParser.new,
          { 'x-amz-copy-source' => "/#{source_bucket_name}/#{source_object_name}" }
        )
      end

      # Get an object from S3
      def get_object(bucket_name, object_name)
        request(
          'GET',
          url(bucket_name, object_name),
          nil
        )
      end

      # Get headers for an object from S3
      def head_object(bucket_name, object_name)
        request(
          'HEAD',
          url(bucket_name, object_name),
          Fog::Parsers::AWS::S3::BasicParser.new
        )
      end

      # Delete an object from S3
      def delete_object(bucket_name, object_name)
        request(
          'DELETE',
          url(bucket_name, object_name),
          Fog::Parsers::AWS::S3::BasicParser.new
        )
      end

      private

      def url(bucket_name = nil, path = nil)
        url  = "#{@scheme}://"
        url << "#{bucket_name}." if bucket_name
        url << "#{@host}:#{@port}/#{path}"
        url
      end

      def canonicalize_amz_headers(headers)
        if headers.empty?
          nil
        else
          headers.select {|key,value| key.match(/^x-amz-/iu)}.sort {|x,y| x[0] <=> y[0]}.collect {|header| header.join(':')}.join("\n").downcase
        end
      end

      def canonicalize_resource(uri)
        resource  = "/"
        if match = uri.host.match(/(.*).s3.amazonaws.com/)
          resource << "#{match[1]}/"
        end
        resource << "#{uri.path[1..-1]}" if uri.path
        resource << "?acl" if uri.to_s.include?('?acl')
        resource << "?location" if uri.to_s.include?('?location')
        resource << "?torrent" if uri.to_s.include?('?torrent')
        resource
      end

      def parse_file(file)
        metadata = {
          :body => nil,
          :headers => {}
        }

        filename = File.basename(file.path)
        unless (mime_types = MIME::Types.of(filename)).empty?
          metadata[:headers]['Content-Type'] = mime_types.first.content_type
        end

        metadata[:body] = file.read
        metadata[:headers]['Content-Length'] = metadata[:body].size.to_s
        metadata[:headers]['Content-MD5'] = Base64.encode64(Digest::MD5.digest(metadata[:body])).strip
        metadata
      end

      def request(method, url, parser, headers = {}, data = nil)
        uri = URI.parse(url)
        headers['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")
        params = [
          method,
          content_md5 = headers['Content-MD5'] || '',
          content_type = headers['Content-Type'] || '',
          headers['Date'],
          canonicalized_amz_headers = canonicalize_amz_headers(headers),
          canonicalized_resource = canonicalize_resource(uri)
        ]
        string_to_sign = params.delete_if {|value| value.nil?}.join("\n")
        hmac = @hmac.update(string_to_sign)
        signature = Base64.encode64(hmac.digest).strip
        headers['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"

        response = nil
        EventMachine::run {
          http = EventMachine.connect(@host, @port, Fog::AWS::Connection) {|connection|
            connection.body = data
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