require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class IAM < Fog::Service

      class EntityAlreadyExists < Fog::AWS::IAM::Error; end
      class KeyPairMismatch < Fog::AWS::IAM::Error; end
      class LimitExceeded < Fog::AWS::IAM::Error; end
      class MalformedCertificate < Fog::AWS::IAM::Error; end
      class ValidationError < Fog::AWS::IAM::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/iam'
      request :add_user_to_group
      request :create_access_key
      request :create_account_alias
      request :create_group
      request :create_login_profile
      request :create_user
      request :delete_access_key
      request :delete_account_alias
      request :delete_group
      request :delete_group_policy
      request :delete_login_profile
      request :delete_server_certificate
      request :delete_signing_certificate
      request :delete_user
      request :delete_user_policy
      request :get_group
      request :get_group_policy
      request :get_login_profile
      request :get_server_certificate
      request :get_user
      request :get_user_policy
      request :list_access_keys
      request :list_account_aliases
      request :list_group_policies
      request :list_groups
      request :list_groups_for_user
      request :list_server_certificates
      request :list_signing_certificates
      request :list_user_policies
      request :list_users
      request :put_group_policy
      request :put_user_policy
      request :remove_user_from_group
      request :update_access_key
      request :update_group
      request :update_login_profile
      request :update_server_certificate
      request :update_signing_certificate
      request :update_user
      request :upload_server_certificate
      request :upload_signing_certificate

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

        # Initialize connection to IAM
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   iam = IAM.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * IAM object with connection to AWS.
        def initialize(options={})
          require 'fog/core/parser'
          require 'multi_json'

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac       = Fog::HMAC.new('sha256', @aws_secret_access_key)
          @host       = options[:host]        || 'iam.amazonaws.com'
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
              :version            => '2010-05-08'
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
              when 'CertificateNotFound', 'NoSuchEntity'
                raise Fog::AWS::IAM::NotFound.slurp(error, match[2])
              when 'EntityAlreadyExists', 'KeyPairMismatch', 'LimitExceeded', 'MalformedCertificate', 'ValidationError'
                raise Fog::AWS::IAM.const_get(match[1]).slurp(error, match[2])
              else
                raise Fog::AWS::IAM::Error.slurp(error, "#{match[1]} => #{match[2]}") if match[1]
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
