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
        request({
          :headers => {},
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetServiceParser.new,
          :url => url
        })
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
        request({
          :body => data,
          :headers => {},
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(bucket_name)
        })
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
        request({
          :body => data,
          :headers => {},
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(bucket_name)
        })
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
        for key, value in options
          query << "#{key}=#{value};"
        end
        query.chop!
        request({
          :headers => {},
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetBucketParser.new,
          :url => url(bucket_name, query)
        })
      end

      # Get configured payer for an S3 bucket
      def get_request_payment(bucket_name)
        request({
          :headers => {},
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetRequestPayment.new,
          :url => url(bucket_name, '?requestpayment')
        })
      end

      # Get location constraint for an S3 bucket
      def get_location(bucket_name)
        request({
          :headers => {},
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetRequestPayment.new,
          :url => url(bucket_name, '?location')
        })
      end

      # Delete an S3 bucket
      #
      # ==== Parameters
      # bucket_name<~String>:: name of bucket to delete
      def delete_bucket(bucket_name)
        request({
          :headers => {},
          :method => 'DELETE',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(bucket_name)
        })
      end

      # Create an object in an S3 bucket
      def put_object(bucket_name, object_name, object, options = {})
        file = parse_file(object)
        request({
          :body => file[:body],
          :headers => options.merge!(file[:headers]),
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(bucket_name, object_name)
        })
      end

      # Copy an object from one S3 bucket to another
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name)
        request({
          :headers => { 'x-amz-copy-source' => "/#{source_bucket_name}/#{source_object_name}" },
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(destination_bucket_name, destination_object_name)
        })
      end

      # Get an object from S3
      def get_object(bucket_name, object_name)
        request({
          :headers => {},
          :method => 'GET',
          :url => url(bucket_name, object_name)
        })
      end

      # Get headers for an object from S3
      def head_object(bucket_name, object_name)
        request({
          :headers => {},
          :method => 'HEAD',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(bucket_name, object_name)
        })
      end

      # Delete an object from S3
      def delete_object(bucket_name, object_name)
        request({
          :headers => {},
          :method => 'DELETE',
          :parser => Fog::Parsers::AWS::S3::BasicParser.new,
          :url => url(bucket_name, object_name)
        })
      end

      private

      def url(bucket_name = nil, path = nil)
        url  = "#{@scheme}://"
        url << "#{bucket_name}." if bucket_name
        url << "#{@host}:#{@port}/#{path}"
        url
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

      def sign(params)
        uri = URI.parse(params[:url])
        params[:headers]['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")

        string_to_sign  = "#{params[:method]}\n"
        string_to_sign << "#{params[:headers]['Content-MD5'] || ''}\n"
        string_to_sign << "#{params[:headers]['Content-Type'] || ''}\n"
        string_to_sign << "#{params[:headers]['Date']}\n"

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
        unless canonical_amz_headers.empty?
          string_to_sign << "#{canonical_amz_headers}\n"
        end

        canonical_resource  = "/"
        # [0..-18] is anything prior to .s3.amazonaws.com
        subdomain = uri.host[0..-18]
        unless subdomain.empty?
          canonical_resource << "#{subdomain}/"
        end
        canonical_resource << "#{uri.path[1..-1]}"
        # canonical_resource << "?acl" if uri.to_s.include?('?acl')
        # canonical_resource << "?location" if uri.to_s.include?('?location')
        # canonical_resource << "?torrent" if uri.to_s.include?('?torrent')
        string_to_sign << "#{canonical_resource}"

        hmac = @hmac.update(string_to_sign)
        signature = Base64.encode64(hmac.digest).chomp!
        params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"
        params
      end

      def request(params)
        params = sign(params)

        response = @connection.request({
          :body => params[:body],
          :headers => params[:headers],
          :method => params[:method],
          :url => params[:url]
        })

        if params[:parser] && !response.body.empty?
          Nokogiri::XML::SAX::Parser.new(params[:parser]).parse(response.body.split(/<\?xml.*\?>/)[1])
          response.body = params[:parser].response
        end

        response
      end

    end
  end
end