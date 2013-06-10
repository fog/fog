require 'fog/aws'
require 'fog/storage'

module Fog
  module Storage
    class AWS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      COMPLIANT_BUCKET_NAMES = /^(?:[a-z]|\d(?!\d{0,2}(?:\.\d{1,3}){3}$))(?:[a-z0-9]|\.(?![\.\-])|\-(?![\.])){1,61}[a-z0-9]$/

      DEFAULT_REGION = 'us-east-1'

      DEFAULT_SCHEME = 'https'
      DEFAULT_SCHEME_PORT = {
        'http' => 80,
        'https' => 443
      }

      VALID_QUERY_KEYS = %w[
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
        restore
        torrent
        uploadId
        uploads
        versionId
        versioning
        versions
        website
      ]

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :path_style

      secrets    :aws_secret_access_key, :hmac

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
      request :post_object_restore
      request :put_bucket
      request :put_bucket_acl
      request :put_bucket_cors
      request :put_bucket_lifecycle
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
            :aws_secret_access_key => @aws_secret_access_key,
            :use_iam_profile => @use_iam_profile
          )
        end

        def http_url(params, expires)
          signed_url(params.merge(:scheme => 'http'), expires)
        end

        def https_url(params, expires)
          signed_url(params.merge(:scheme => 'https'), expires)
        end

        def url(params, expires)
          Fog::Logger.deprecation("Fog::Storage::AWS => #url is deprecated, use #https_url instead [light_black](#{caller.first})[/]")
          https_url(params, expires)
        end

        def request_url(params)
          params = request_params(params)
          params_to_url(params)
        end

        def signed_url(params, expires)
          expires = expires.to_i
          signature = signature(params, expires)
          params = request_params(params)

          params[:query] = (params[:query] || {}).merge({
            'AWSAccessKeyId' => @aws_access_key_id,
            'Signature' => signature,
            'Expires' => expires,
          })
          params[:query]['x-amz-security-token'] = @aws_session_token if @aws_session_token

          params_to_url(params)
        end

        private

        def region_to_host(region=nil)
          case region.to_s
          when DEFAULT_REGION, ''
            's3.amazonaws.com'
          else
            "s3-#{region}.amazonaws.com"
          end
        end

        def object_to_path(object_name=nil)
          '/' + Fog::AWS.escape(object_name.to_s).gsub('%2F','/')
        end

        def bucket_to_path(bucket_name, path=nil)
          "/#{Fog::AWS.escape(bucket_name.to_s)}#{path}"
        end

        # Transforms things like bucket_name, object_name, region
        #
        # Should yield the same result when called f*f
        def request_params(params)
          headers  = params[:headers] || {}

          if params[:scheme]
            scheme = params[:scheme]
            port   = params[:port]
          else
            scheme = @scheme || DEFAULT_SCHEME
            port   = @port
          end
          if DEFAULT_SCHEME_PORT[scheme] == port
            port = nil
          end

          if params[:region]
            region = params[:region]
            host   = params[:host] || region_to_host(region)
          else
            region = @region       || DEFAULT_REGION
            host   = params[:host] || @host || region_to_host(region)
          end

          path     = params[:path] || object_to_path(params[:object_name])
          path     = '/' + path if path[0..0] != '/'

          if params[:bucket_name]
            bucket_name = params[:bucket_name]

            path_style = params.fetch(:path_style, @path_style)
            if !path_style && COMPLIANT_BUCKET_NAMES !~ bucket_name
              Fog::Logger.warning("fog: the specified s3 bucket name(#{bucket_name}) is not a valid dns name, which will negatively impact performance.  For details see: http://docs.amazonwebservices.com/AmazonS3/latest/dev/BucketRestrictions.html")
              path_style = true
            end

            if path_style
              path = bucket_to_path bucket_name, path
            else
              host = [bucket_name, host].join('.')
            end
          end

          ret = params.merge({
            :scheme       => scheme,
            :host         => host,
            :port         => port,
            :path         => path,
            :headers      => headers,
          })

          #
          ret.delete(:path_style)
          ret.delete(:bucket_name)
          ret.delete(:object_name)
          ret.delete(:region)

          ret
        end

        def params_to_url(params)
          query = params[:query] && params[:query].map do |key, value|
            if value
              [key, Fog::AWS.escape(value.to_s)].join('=')
            else
              key
            end
          end.join('&')

          URI::Generic.build({
            :scheme => params[:scheme],
            :host   => params[:host],
            :port   => params[:port],
            :path   => params[:path],
            :query  => query,
          }).to_s
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
          require 'mime/types'
          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @region = options[:region] || DEFAULT_REGION
          @host   = options[:host]   || region_to_host(@region)
          @scheme = options[:scheme] || DEFAULT_SCHEME
        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end

        def signature(params, expires)
          "foo"
        end

        def setup_credentials(options)
          @aws_access_key_id = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @aws_session_token     = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]
        end

      end

      class Real
        include Utils
        include Fog::AWS::CredentialFetcher::ConnectionMethods
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

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @connection_options     = options[:connection_options] || {}
          @persistent = options.fetch(:persistent, false)

          if @endpoint = options[:endpoint]
            endpoint = URI.parse(@endpoint)
            @host = endpoint.host
            @path = if endpoint.path.empty?
              '/'
            else
              endpoint.path
            end
            @scheme = endpoint.scheme
            @port = endpoint.port
          else
            @region     = options[:region]      || DEFAULT_REGION
            @host       = options[:host]        || region_to_host(@region)
            @path       = options[:path]        || '/'
            @scheme     = options[:scheme]      || DEFAULT_SCHEME
            @port       = options[:port]        || DEFAULT_SCHEME_PORT[@scheme]
            @path_style = options[:path_style]  || false
          end

          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def signature(params, expires)
          headers = params[:headers] || {}

          string_to_sign =
<<-DATA
#{params[:method].to_s.upcase}
#{headers['Content-MD5']}
#{headers['Content-Type']}
#{expires}
DATA

          amz_headers, canonical_amz_headers = {}, ''
          for key, value in headers
            if key[0..5] == 'x-amz-'
              amz_headers[key] = value
            end
          end
          amz_headers = amz_headers.sort {|x, y| x[0] <=> y[0]}
          for key, value in amz_headers
            canonical_amz_headers << "#{key}:#{value}\n"
          end
          string_to_sign << canonical_amz_headers


          query_string = ''
          if params[:query]
            query_args = []
            for key in params[:query].keys.sort
              if VALID_QUERY_KEYS.include?(key)
                value = params[:query][key]
                if value
                  query_args << "#{key}=#{value}"
                else
                  query_args << key
                end
              end
            end
            if query_args.any?
              query_string = '?' + query_args.join('&')
            end
          end

          canonical_path = (params[:path] || object_to_path(params[:object_name])).to_s
          canonical_path = '/' + canonical_path if canonical_path[0..0] != '/'
          if params[:bucket_name]
            canonical_resource = "/#{params[:bucket_name]}#{canonical_path}"
          else
            canonical_resource = canonical_path
          end
          canonical_resource << query_string
          string_to_sign << canonical_resource

          signed_string = @hmac.sign(string_to_sign)
          Base64.encode64(signed_string).chomp!
        end

        private

        def setup_credentials(options)
          @aws_access_key_id     = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @aws_session_token     = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @hmac = Fog::HMAC.new('sha1', @aws_secret_access_key)
        end

        def request(params, &block)
          refresh_credentials_if_expired

          expires = Fog::Time.now.to_date_header
          signature = signature(params, expires)

          params = request_params(params)
          params.delete(:port) unless params[:port]

          params[:headers]['Date'] = expires
          params[:headers]['x-amz-security-token'] = @aws_session_token if @aws_session_token
          params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature}"
          # FIXME: ToHashParser should make this not needed
          original_params = params.dup

          begin
            response = @connection.request(params, &block)
          rescue Excon::Errors::TemporaryRedirect => error
            headers = (error.response.is_a?(Hash) ? error.response[:headers] : error.response.headers)
            uri = URI.parse(headers['Location'])
            Fog::Logger.warning("fog: followed redirect to #{uri.host}, connecting to the matching region will be more performant")
            response = Fog::Connection.new("#{@scheme}://#{uri.host}:#{@port}", false, @connection_options).request(original_params, &block)
          end

          response
        end
      end
    end
  end
end
