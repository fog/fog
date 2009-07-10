require 'rubygems'
require 'base64'
require 'cgi'
require 'digest/md5'
require 'hmac-sha1'
require 'mime/types'

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
      #   sdb = S3.new(
      #     :aws_access_key_id => your_aws_access_key_id,
      #     :aws_secret_access_key => your_aws_secret_access_key
      #   )
      #
      # ==== Parameters
      # * options<~Hash> - config arguments for connection.  Defaults to {}.
      #
      # ==== Returns
      # * S3 object with connection to aws.
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
      #
      # ==== Parameters
      # FIXME: docs
      def get_service
        request({
          :headers => {},
          :host => @host,
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetServiceParser.new,
          :url => @host
        })
      end

      # Create an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to create
      # * options<~Hash> - config arguments for bucket.  Defaults to {}.
      #   * :location_constraint<~Symbol> - sets the location for the bucket
      def put_bucket(bucket_name, options = {})
        if options[:location_constraint]
          data =
<<-DATA
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
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT'
        })
      end

      # Change who pays for requests to an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to modify
      # * payer<~String> - valid values are BucketOwner or Requester
      def put_request_payment(bucket_name, payer)
        data =
<<-DATA
<RequestPaymentConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Payer>#{payer}</Payer>
</RequestPaymentConfiguration>
DATA
        request({
          :body => data,
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT',
          :query => "requestPayment"
        })
      end

      # List information about objects in an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to list object keys from
      # * options<~Hash> - config arguments for list.  Defaults to {}.
      #   * :prefix - limits object keys to those beginning with its value.
      #   * :marker - limits object keys to only those that appear
      #     lexicographically after its value.
      #   * maxkeys - limits number of object keys returned
      #   * :delimiter - causes keys with the same string between the prefix
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
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetBucketParser.new,
          :query => query
        })
      end

      # Get configured payer for an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to get payer for
      #
      # ==== Returns
      # FIXME: docs
      def get_request_payment(bucket_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetRequestPayment.new,
          :query => 'requestPayment'
        })
      end

      # Get location constraint for an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to get location constraint for
      #
      # ==== Returns
      # FIXME: docs
      def get_bucket_location(bucket_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :parser => Fog::Parsers::AWS::S3::GetBucketLocation.new,
          :query => 'location'
        })
      end

      # Delete an S3 bucket
      #
      # ==== Parameters
      # * bucket_name<~String> - name of bucket to delete
      #
      # ==== Returns
      # FIXME: docs
      def delete_bucket(bucket_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'DELETE'
        })
      end

      # Create an object in an S3 bucket
      # FIXME: docs
      def put_object(bucket_name, object_name, object, options = {})
        file = parse_file(object)
        request({
          :body => file[:body],
          :headers => options.merge!(file[:headers]),
          :host => "#{bucket_name}.#{@host}",
          :method => 'PUT',
          :path => object_name
        })
      end

      # Copy an object from one S3 bucket to another
      # FIXME: docs
      def copy_object(source_bucket_name, source_object_name, destination_bucket_name, destination_object_name)
        request({
          :headers => { 'x-amz-copy-source' => "/#{source_bucket_name}/#{source_object_name}" },
          :host => "#{destination_bucket_name}.#{@host}",
          :method => 'PUT',
          :parser => Fog::Parsers::AWS::S3::CopyObject.new,
          :path => destination_object_name
        })
      end

      # Get an object from S3
      # FIXME: docs
      def get_object(bucket_name, object_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'GET',
          :path => object_name
        })
      end

      # Get headers for an object from S3
      # FIXME: docs
      def head_object(bucket_name, object_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'HEAD',
          :path => object_name
        })
      end

      # Delete an object from S3
      # FIXME: docs
      def delete_object(bucket_name, object_name)
        request({
          :headers => {},
          :host => "#{bucket_name}.#{@host}",
          :method => 'DELETE',
          :path => object_name
        })
      end

      private

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

      def request(params)
        params[:headers]['Date'] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S +0000")

        string_to_sign =
<<-DATA
#{params[:method]}
#{params[:headers]['Content-MD5']}
#{params[:headers]['Content-Type']}
#{params[:headers]['Date']}
DATA

        amz_headers, canonical_amz_headers = {}, ''
        for key, value in params[:headers]
          if key[0..5] == 'x-amz-'
            amz_headers[key] = value
          end
        end
        amz_headers = amz_headers.sort {|x, y| x[0] <=> y[0]}
        for pair in amz_headers
          canonical_amz_headers << "#{pair[0]}:#{pair[1]}\n"
        end
        string_to_sign << "#{canonical_amz_headers}"

        canonical_resource  = "/"
        # [0..-18] is anything prior to .s3.amazonaws.com
        subdomain = params[:host][0..-18]
        unless subdomain.empty?
          canonical_resource << "#{subdomain}/"
        end
        canonical_resource << "#{params[:path]}"
        if params[:query] && !params[:query].empty?
          canonical_resource << "?#{params[:query]}"
        end
        string_to_sign << "#{canonical_resource}"

        hmac = @hmac.update(string_to_sign)
        signature = Base64.encode64(hmac.digest).chomp!
        params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"

        response = @connection.request({
          :body => params[:body],
          :headers => params[:headers],
          :host => params[:host],
          :method => params[:method],
          :path => params[:path],
          :query => params[:query]
        })

        if params[:parser] && !response.body.empty?
          Nokogiri::XML::SAX::Parser.new(params[:parser]).parse(response.body)
          response.body = params[:parser].response
        end

        response
      end

    end
  end
end