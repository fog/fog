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
        @connection = AWS::Connection.new("#{@scheme}://#{@host}:#{@port}")
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
        amz_headers, canonical_amz_headers = {}, ''
        for key, value in amz_headers
          if key[0..5] == 'x-amz-'
            amz_headers[key] = value
          end
        end
        amz_headers = amz_headers.sort {|x, y| x[0] <=> y[0]}
        for pair in amz_headers
          canonical_amz_headers << "#{pair[0]}: #{pair[1]}\r\n"
        end
        if canonical_amz_headers.empty?
          nil
        else
          canonical_amz_headers.chomp!
        end
      end

      def canonicalize_resource(uri)
        resource  = "/"
        if match = uri.host.match(/(.*).s3.amazonaws.com/)
          resource << "#{match[1]}/"
        end
        resource << "#{uri.path[1..-1]}"
        # resource << "?acl" if uri.to_s.include?('?acl')
        # resource << "?location" if uri.to_s.include?('?location')
        # resource << "?torrent" if uri.to_s.include?('?torrent')
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

      def request(method, url, parser, headers = {}, body = nil)
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
        string_to_sign = ''
        for value in params
          unless value.nil?
            string_to_sign << "#{value}\n"
          end
        end
        hmac = @hmac.update(string_to_sign.chomp!)
        signature = Base64.encode64(hmac.digest).strip!
        headers['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"

        response = @connection.request({
          :body => body,
          :headers => headers,
          :method => method,
          :url => url
        })

        if parser && !response.body.empty?
          Nokogiri::XML::SAX::Parser.new(parser).parse(response.body.split(/<\?xml.*\?>/)[1])
          response.body = parser.response
        end

        response
      end

    end
  end
end