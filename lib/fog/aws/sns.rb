require 'fog/aws/core'

module Fog
  module AWS
    class SNS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent, :region, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at

      request_path 'fog/aws/requests/sns'
      request :add_permission
      request :confirm_subscription
      request :create_topic
      request :delete_topic
      request :get_topic_attributes
      request :list_subscriptions
      request :list_subscriptions_by_topic
      request :list_topics
      request :publish
      request :remove_permission
      request :set_topic_attributes
      request :subscribe
      request :unsubscribe

      class Mock

        def initialize(options={})
        end

      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to SNS
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   sns = SNS.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * SNS object with connection to AWS.
        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @connection_options     = options[:connection_options] || {}

          options[:region] ||= 'us-east-1'
          @host = options[:host] || "sns.#{options[:region]}.amazonaws.com"

          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token     = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @hmac       = Fog::HMAC.new('sha256', @aws_secret_access_key)
        end

        def request(params)
          refresh_credentials_if_expired

          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :aws_session_token  => @aws_session_token,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port
            }
          )

          response = @connection.request({
            :body       => body,
            :expects    => 200,
            :idempotent => idempotent,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :method     => 'POST',
            :parser     => parser
          })

          response
        end

      end
    end
  end
end
