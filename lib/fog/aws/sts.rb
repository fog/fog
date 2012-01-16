require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class STS < Fog::Service

      class EntityAlreadyExists < Fog::AWS::STS::Error; end
      class ValidationError < Fog::AWS::STS::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/sts'
      request :get_federation_token
      request :get_session_token

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
          @aws_access_key_id = options[:aws_access_key_id]
        end

        def data
          self.class.data[@aws_access_key_id]
        end

        def reset_data
          self.class.data.delete(@aws_access_key_id)
        end
      end

      class Real

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
          require 'fog/core/parser'
          require 'multi_json'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac       = Fog::HMAC.new('sha256', @aws_secret_access_key)
          @host       = options[:host]        || 'sts.amazonaws.com'
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

        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = Fog::AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2011-06-15'
            }
          )

          begin
            response = @connection.request({
              :body       => body,
              :expects    => 200,
              :idempotent => idempotent,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :host       => @host,
              :method     => 'POST',
              :parser     => parser
            })

            response
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.message.match(/<Code>(.*)<\/Code>(?:.*<Message>(.*)<\/Message>)?/m)
              case match[1]
              when 'EntityAlreadyExists', 'KeyPairMismatch', 'LimitExceeded', 'MalformedCertificate', 'ValidationError'
                raise Fog::AWS::STS.const_get(match[1]).slurp(error, match[2])
              else
                raise Fog::AWS::STS::Error.slurp(error, "#{match[1]} => #{match[2]}") if match[1]
                raise
              end
            else
              raise
            end
          end


        end

      end
    end
  end
end
