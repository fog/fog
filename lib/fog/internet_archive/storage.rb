require 'fog/internet_archive/core'

module Fog
  module Storage
    class InternetArchive < Fog::Service
      requires :ia_access_key_id, :ia_secret_access_key
      recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent, :ia_session_token, :ia_credentials_expire_at

      secrets    :ia_secret_access_key, :hmac

      model_path 'fog/internet_archive/models/storage'
      collection  :directories
      model       :directory
      collection  :files
      model       :file

      request_path 'fog/internet_archive/requests/storage'
      request :abort_multipart_upload
      request :complete_multipart_upload
      request :copy_object
      request :delete_bucket
      request :delete_bucket_cors
      request :delete_bucket_lifecycle
      request :delete_bucket_policy
      request :delete_bucket_website
      request :delete_object
      request :delete_multiple_objects
      request :get_bucket
      request :get_bucket_acl
      request :get_bucket_cors
      request :get_bucket_lifecycle
      request :get_bucket_location
      request :get_bucket_logging
      request :get_bucket_policy
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
      request :put_bucket_cors
      request :put_bucket_lifecycle
      request :put_bucket_logging
      request :put_bucket_policy
      request :put_bucket_website
      request :put_object
      request :put_object_acl
      request :put_object_url
      request :put_request_payment
      request :sync_clock
      request :upload_part

      module Utils
        attr_accessor :region

        def http_url(params, expires)
          scheme_host_path_query(params.merge(:scheme => 'http', :port => 80), expires)
        end

        def https_url(params, expires)
          scheme_host_path_query(params.merge(:scheme => 'https', :port => 443), expires)
        end

        def url(params, expires)
          Fog::Logger.deprecation("Fog::Storage::InternetArchive => #url is deprecated, use #https_url instead [light_black](#{caller.first})[/]")
          http_url(params, expires)
        end

        private

        def scheme_host_path_query(params, expires)
          params[:scheme] ||= @scheme
          if params[:port] == 80 && params[:scheme] == 'http'
            params.delete(:port)
          end
          if params[:port] == 443 && params[:scheme] == 'https'
            params.delete(:port)
          end
          params[:headers] ||= {}
          params[:headers]['Date'] = expires.to_i
          params[:path] = Fog::InternetArchive.escape(params[:path]).gsub('%2F', '/')
          query = []
          params[:headers]['x-amz-security-token'] = @ia_session_token if @ia_session_token
          if params[:query]
            for key, value in params[:query]
              query << "#{key}=#{Fog::InternetArchive.escape(value)}"
            end
          end
          query << "AWSAccessKeyId=#{@ia_access_key_id}"
          query << "Signature=#{Fog::InternetArchive.escape(signature(params))}"
          query << "Expires=#{params[:headers]['Date']}"
          query << "x-amz-security-token=#{Fog::InternetArchive.escape(@ia_session_token)}" if @ia_session_token
          port_part = params[:port] && ":#{params[:port]}"
          "#{params[:scheme]}://#{params[:host]}#{port_part}/#{params[:path]}?#{query.join('&')}"
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
                :buckets => {},
                :cors => {
                  :bucket => {}
                }
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          setup_credentials(options)
          options[:region] ||= 'us-east-1'
          @host = options[:host] || Fog::InternetArchive::API_DOMAIN_NAME
          @scheme = options[:scheme] || 'http'
          @region = options[:region]
        end

        def data
          self.class.data[@region][@ia_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@ia_access_key_id)
        end

        def signature(params)
          "foo"
        end

        def setup_credentials(options)
          @ia_access_key_id = options[:ia_access_key_id]
          @ia_secret_access_key = options[:ia_secret_access_key]
          @ia_session_token     = options[:ia_session_token]
          @ia_credentials_expire_at = options[:ia_credentials_expire_at]
        end
      end

      class Real
        include Utils
        # include Fog::InternetArchive::CredentialFetcher::ConnectionMethods
        # Initialize connection to S3
        #
        # ==== Notes
        # options parameter must include values for :ia_access_key_id and
        # :ia_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   s3 = Fog::Storage.new(
        #     :provider => "InternetArchive",
        #     :ia_access_key_id => your_ia_access_key_id,
        #     :ia_secret_access_key => your_ia_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * S3 object with connection to aws.
        def initialize(options={})

          setup_credentials(options)
          @connection_options     = options[:connection_options] || {}

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
            @region = options[:region]
            @host = options[:host] || Fog::InternetArchive::API_DOMAIN_NAME
            @path       = options[:path]        || '/'
            @persistent = options.fetch(:persistent, false)
            @port       = options[:port]        || 80
            @scheme     = options[:scheme]      || 'http'
          end
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
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
            canonical_resource << "#{Fog::InternetArchive.escape(subdomain).downcase}/"
          end
          canonical_resource << params[:path].to_s
          canonical_resource << '?'
          for key in (params[:query] || {}).keys.sort
            if %w{
              acl
              cors
              delete
              lifecycle
              location
              logging
              notification
              partNumber
              policy
              requestPayment
              response-cache-control
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
          Base64.encode64(signed_string).chomp!
        end

        private

        def setup_credentials(options)
          @ia_access_key_id     = options[:ia_access_key_id]
          @ia_secret_access_key = options[:ia_secret_access_key]
          @ia_session_token     = options[:ia_session_token]
          @ia_credentials_expire_at = options[:ia_credentials_expire_at]

          @hmac = Fog::HMAC.new('sha1', @ia_secret_access_key)
        end

        def request(params, &block)
          # refresh_credentials_if_expired

          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['x-amz-security-token'] = @ia_session_token if @ia_session_token
          params[:headers]['Authorization'] = "AWS #{@ia_access_key_id}:#{signature(params)}"
          # FIXME: ToHashParser should make this not needed
          original_params = params.dup

          begin
            response = @connection.request(params, &block)
          rescue Excon::Errors::TemporaryRedirect => error
            uri = URI.parse(error.response.headers['location'])
            Fog::Logger.warning("fog: followed redirect to #{uri.host}, connecting to the matching region will be more performant")
            response = Fog::XML::Connection.new("#{@scheme}://#{uri.host}:#{@port}", false, @connection_options).request(original_params, &block)
          end

          response
        end
      end
    end
  end
end
