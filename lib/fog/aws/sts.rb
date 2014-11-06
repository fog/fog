require 'fog/aws/core'

module Fog
  module AWS
    class STS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      class EntityAlreadyExists < Fog::AWS::STS::Error; end
      class ValidationError < Fog::AWS::STS::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent, :aws_session_token, :use_iam_profile, :aws_credentials_expire_at, :instrumentor, :instrumentor_name

      request_path 'fog/aws/requests/sts'
      request :get_federation_token
      request :get_session_token
      request :assume_role

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :owner_id => Fog::AWS::Mock.owner_id,
              :server_certificates => {}
            }
          end
        end

        def self.reset
          @data = nil
        end

        def self.server_certificate_id
          Fog::Mock.random_hex(16)
        end

        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
        end

        def data
          self.class.data[@aws_access_key_id]
        end

        def reset_data
          self.class.data.delete(@aws_access_key_id)
        end

        def setup_credentials(options)
          @aws_access_key_id = options[:aws_access_key_id]
        end
      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to STS
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   iam = STS.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * STS object with connection to AWS.
        def initialize(options={})

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @instrumentor       = options[:instrumentor]
          @instrumentor_name  = options[:instrumentor_name] || 'fog.aws.sts'
          @connection_options     = options[:connection_options] || {}

          @host       = options[:host]        || 'sts.amazonaws.com'
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
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

          @signer = Fog::AWS::SignatureV4.new(@aws_access_key_id, @aws_secret_access_key, 'us-east-1', 'sts')
        end

        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body, headers = Fog::AWS.signed_params_v4(
            params,
            { 'Content-Type' => 'application/x-www-form-urlencoded' },
            {
              :method             => 'POST',
              :aws_session_token  => @aws_session_token,
              :signer             => @signer,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2011-06-15'
            }
          )

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(body, headers, idempotent, parser)
            end
          else
            _request(body, headers, idempotent, parser)
          end
        end

        def _request(body, headers, idempotent, parser)
          @connection.request({
            :body       => body,
            :expects    => 200,
            :idempotent => idempotent,
            :headers    => headers,
            :method     => 'POST',
            :parser     => parser
          })
        rescue Excon::Errors::HTTPStatusError => error
          match = Fog::AWS::Errors.match_error(error)
          raise if match.empty?
          raise case match[:code]
                when 'EntityAlreadyExists', 'KeyPairMismatch', 'LimitExceeded', 'MalformedCertificate', 'ValidationError'
                  Fog::AWS::STS.const_get(match[:code]).slurp(error, match[:message])
                else
                  Fog::AWS::STS::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
                end
        end
      end
    end
  end
end
