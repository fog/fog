require 'fog/aws'
require 'fog/cdn'

module Fog
  module CDN
    class AWS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :version, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at

      model_path 'fog/aws/cdn/models'

      request_path 'fog/aws/requests/cdn'
      request 'delete_distribution'
      request 'delete_streaming_distribution'
      request 'get_distribution'
      request 'get_distribution_list'
      request 'get_invalidation_list'
      request 'get_streaming_distribution'
      request 'get_streaming_distribution_list'
      request 'post_distribution'
      request 'post_streaming_distribution'
      request 'post_invalidation'
      request 'put_distribution_config'
      request 'put_streaming_distribution_config'

      class Mock

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
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
          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @region             = options[:region]
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

        def setup_credentials(options={})
          @aws_access_key_id  = options[:aws_access_key_id]
        end
      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to Cloudfront
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   cdn = Fog::AWS::CDN.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * cdn object with connection to aws.
        def initialize(options={})
          require 'fog/core/parser'

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @connection_options = options[:connection_options] || {}
          @host       = options[:host]      || 'cloudfront.amazonaws.com'
          @path       = options[:path]      || '/'
          @persistent = options.fetch(:persistent, true)
          @port       = options[:port]      || 443
          @scheme     = options[:scheme]    || 'https'
          @version    = options[:version]  || '2010-11-01'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options)
          @aws_access_key_id     = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @aws_session_token     = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @hmac       = Fog::HMAC.new('sha1', @aws_secret_access_key)
        end

        def request(params, &block)
          refresh_credentials_if_expired

          params[:headers] ||= {}
          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['x-amz-security-token'] = @aws_session_token if @aws_session_token
          params[:headers]['Authorization'] = "AWS #{@aws_access_key_id}:#{signature(params)}"
          params[:path] = "/#{@version}/#{params[:path]}" 
          @connection.request(params, &block)
        end

        def signature(params)
          string_to_sign = params[:headers]['Date']
          signed_string = @hmac.sign(string_to_sign)
          Base64.encode64(signed_string).chomp!
        end
      end
    end
  end
end
