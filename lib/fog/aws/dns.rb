require 'fog/aws/core'

module Fog
  module DNS
    class AWS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :version, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :instrumentor, :instrumentor_name

      model_path 'fog/aws/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

      request_path 'fog/aws/requests/dns'
      request :create_health_check
      request :create_hosted_zone
      request :delete_health_check
      request :get_health_check
      request :get_hosted_zone
      request :delete_hosted_zone
      request :list_health_checks
      request :list_hosted_zones
      request :change_resource_record_sets
      request :list_resource_record_sets
      request :get_change

      class Mock
        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :buckets => {},
                :limits => {
                  :duplicate_domains => 5
                },
                :zones => {},
                :changes => {}
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
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

        def setup_credentials(options)
          @aws_access_key_id  = options[:aws_access_key_id]
        end
      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to Route 53 DNS service
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   dns = Fog::AWS::DNS.new(
        #     :aws_access_key_id => your_aws_access_key_id,
        #     :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * dns object with connection to aws.
        def initialize(options={})

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @instrumentor       = options[:instrumentor]
          @instrumentor_name  = options[:instrumentor_name] || 'fog.aws.dns'
          @connection_options     = options[:connection_options] || {}
          @host       = options[:host]        || 'route53.amazonaws.com'
          @path       = options[:path]        || '/'
          @persistent = options.fetch(:persistent, true)
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @version    = options[:version]     || '2013-04-01'

          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token      = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @hmac       = Fog::HMAC.new('sha1', @aws_secret_access_key)
        end

        def request(params, &block)
          refresh_credentials_if_expired

          params[:headers] ||= {}
          params[:headers]['Date'] = Fog::Time.now.to_date_header
          params[:headers]['x-amz-security-token'] = @aws_session_token if @aws_session_token
          params[:headers]['X-Amzn-Authorization'] = "AWS3-HTTPS AWSAccessKeyId=#{@aws_access_key_id},Algorithm=HmacSHA1,Signature=#{signature(params)}"
          params[:path] = "/#{@version}/#{params[:path]}"

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(params, &block)
            end
          else
            _request(params, &block)
          end
        end

        def _request(params, &block)
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
