require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))
require 'fog/storage'

module Fog
  module Storage
    class AWS < Fog::Service

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent

      model_path 'fog/aws/models/storage'
      collection  :directories
      model       :directory
      collection  :files
      model       :file

      request_path 'fog/aws/requests/storage'
      request :abort_multipart_upload
      request :complete_multipart_upload
      request :copy_object
      request :delete_bucket
      request :delete_bucket_policy
      request :delete_bucket_website
      request :delete_object
      request :get_bucket
      request :get_bucket_acl
      request :get_bucket_location
      request :get_bucket_logging
      request :get_bucket_object_versions
      request :get_bucket_policy
      request :get_bucket_versioning
      request :get_bucket_website
      request :get_object
      request :get_object_acl
      request :get_object_torrent
      request :get_object_http_url
      request :get_object_https_url
      request :get_object_url
      request :get_request_payment
      request :get_service
      request :head_object
      request :initiate_multipart_upload
      request :list_multipart_uploads
      request :list_parts
      request :post_object_hidden_fields
      request :put_bucket
      request :put_bucket_acl
      request :put_bucket_logging
      request :put_bucket_policy
      request :put_bucket_versioning
      request :put_bucket_website
      request :put_object
      request :put_object_acl
      request :put_object_url
      request :put_request_payment
      request :sync_clock
      request :upload_part

      module Utils

        attr_accessor :region

        def cdn
          @cdn ||= Fog::AWS::CDN.new(
            :aws_access_key_id => @aws_access_key_id,
            :aws_secret_access_key => @aws_secret_access_key
          )
        end

        def http_url(params, expires)
          "http://" << host_path_query(params, expires)
        end

        def https_url(params, expires)
          "https://" << host_path_query(params, expires)
        end

        def url(params, expires)
          Fog::Logger.deprecation("Fog::Storage::AWS => #url is deprecated, use #https_url instead [light_black](#{caller.first})[/]")
          https_url(params, expires)
        end

        private

        def host_path_query(params, expires)
          params[:headers] ||= {}
          params[:headers]['Date'] = expires.to_i
          params[:path] = Fog::AWS.escape(params[:path]).gsub('%2F', '/')
          query = []
          if params[:query]
            for key, value in params[:query]
              query << "#{key}=#{Fog::AWS.escape(value)}"
            end
          end
          query << "AWSAccessKeyId=#{@aws_access_key_id}"
          query << "Signature=#{Fog::AWS.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          "#{@host}/#{params[:path]}?#{query.join('&')}"
        end

      end

      class Mock
        include Utils

        def self.acls(type)
          case type
          when 'private'
            {
              "AccessControlList" => [
                {
                  "Permission" => "FULL_CONTROL",
                  "Grantee" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
                }
              ],
              "Owner" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          when 'public-read'
            {
              "AccessControlList" => [
                {
                  "Permission" => "FULL_CONTROL",
                  "Grantee" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
                },
                {
                  "Permission" => "READ",
                  "Grantee" => {"URI" => "http://acs.amazonaws.com/groups/global/AllUsers"}
                }
              ],
              "Owner" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          when 'public-read-write'
            {
              "AccessControlList" => [
                {
                  "Permission" => "FULL_CONTROL",
                  "Grantee" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
                },
                {
                  "Permission" => "READ",
                  "Grantee" => {"URI" => "http://acs.amazonaws.com/groups/global/AllUsers"}
                },
                {
                  "Permission" => "WRITE",
                  "Grantee" => {"URI" => "http://acs.amazonaws.com/groups/global/AllUsers"}
                }
              ],
              "Owner" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          when 'authenticated-read'
            {
              "AccessControlList" => [
                {
                  "Permission" => "FULL_CONTROL",
                  "Grantee" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
                },
                {
                  "Permission" => "READ",
                  "Grantee" => {"URI" => "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"}
                }
              ],
              "Owner" => {"DisplayName" => "me", "ID" => "2744ccd10c7533bd736ad890f9dd5cab2adb27b07d500b9493f29cdc420cb2e0"}
            }
          end
        end

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :acls => {
                  :bucket => {},
                  :object => {}
                },
                :buckets => {}
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          require 'multi_json'
          @aws_access_key_id = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'ap-northeast-1'
            's3-ap-northeast-1.amazonaws.com'
          when 'ap-southeast-1'
            's3-ap-southeast-1.amazonaws.com'
          when 'eu-west-1'
            's3-eu-west-1.amazonaws.com'
          when 'us-east-1'
            's3.amazonaws.com'
          when 'us-west-1'
            's3-us-west-1.amazonaws.com'
          when 'us-west-2'
            's3-us-west-2.amazonaws.com'
          else
            raise ArgumentError, "Unknown region: #{options[:region].inspect}"
          end
          @region = options[:region]
        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end

        def signature(params)
          "foo"
        end

      end

      class Real
        include Utils

        # Initialize connection to S3
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   s3 = Fog::Storage.new(
        #     :provider => "AWS",
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
          require 'fog/core/parser'
          require 'mime/types'

          @aws_access_key_id = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac = Fog::HMAC.new('sha1', @aws_secret_access_key)
          if @endpoint = options[:endpoint]
            endpoint = URI.parse(@endpoint)
            @host = endpoint.host
            @path = if endpoint.path.empty?
              '/'
            else
              endpoint.path
            end
            @port = endpoint.port
            @scheme = endpoint.scheme
          else
            options[:region] ||= 'us-east-1'
            @host = options[:host] || case options[:region]
            when 'ap-northeast-1'
              's3-ap-northeast-1.amazonaws.com'
            when 'ap-southeast-1'
              's3-ap-southeast-1.amazonaws.com'
            when 'eu-west-1'
              's3-eu-west-1.amazonaws.com'
            when 'us-east-1'
              's3.amazonaws.com'
            when 'us-west-1'
              's3-us-west-1.amazonaws.com'
            when 'us-west-2'
              's3-us-west-2.amazonaws.com'
            else
              raise ArgumentError, "Unknown region: #{options[:region].inspect}"
            end
            @path       = options[:path]        || '/'
            @persistent = options[:persistent]  || true
            @port       = options[:port]        || 443
            @scheme     = options[:scheme]      || 'https'
          end
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def signature(params)
          string_to_sign =
<<-DATA
#{params[:method].to_s.upcase}
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
          for key, value in amz_headers
            canonical_amz_headers << "#{key}:#{value}\n"
          end
          string_to_sign << canonical_amz_headers

          subdomain = params[:host].split(".#{@host}").first
          unless subdomain =~ /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/
            Fog::Logger.warning("fog: the specified s3 bucket name(#{subdomain}) is not a valid dns name, which will negatively impact performance.  For details see: http://docs.amazonwebservices.com/AmazonS3/latest/dev/BucketRestrictions.html")
            params[:host] = params[:host].split("#{subdomain}.")[-1]
            if params[:path]
              params[:path] = "#{subdomain}/#{params[:path]}"
            else
              params[:path] = subdomain
            end
            subdomain = nil
          end

          canonical_resource  = @path.dup
          unless subdomain.nil? || subdomain == @host
            canonical_resource << "#{Fog::AWS.escape(subdomain).downcase}/"
          end
          canonical_resource << params[:path].to_s
          canonical_resource << '?'
          for key in (params[:query] || {}).keys.sort
            if %w{
              acl
              location
              logging
              notification
              partNumber
              policy
              requestPayment
              reponse-cache-control
              response-content-disposition
              response-content-encoding
              response-content-language
              response-content-type
              response-expires
              torrent
              uploadId
              uploads
              versionId
              versioning
              versions
              website
            }.include?(key)
              canonical_resource << "#{key}#{"=#{params[:query][key]}" unless params[:query][key].nil?}&"
            end
          end
          canonical_resource.chop!
          string_to_sign << canonical_resource

          signed_string = @hmac.sign(string_to_sign)
          signature = Base64.encode64(signed_string).chomp!
        end

        private

        def request(params, &block)
          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature(params)}"

          # FIXME: ToHashParser should make this not needed
          original_params = params.dup

          begin
            response = @connection.request(params, &block)
          rescue Excon::Errors::TemporaryRedirect => error
            uri = URI.parse(error.response.headers['Location'])
            Fog::Logger.warning("fog: followed redirect to #{uri.host}, connecting to the matching region will be more performant")
            response = Fog::Connection.new("#{@scheme}://#{uri.host}:#{@port}", false, @connection_options).request(original_params, &block)
          end

          response
        end
      end
    end
  end
end
