require 'fog/aws'

module Fog
  module AWS
    class IAM < Fog::Service

      class EntityAlreadyExists < Fog::AWS::IAM::Error; end
      class KeyPairMismatch < Fog::AWS::IAM::Error; end
      class LimitExceeded < Fog::AWS::IAM::Error; end
      class MalformedCertificate < Fog::AWS::IAM::Error; end
      class ValidationError < Fog::AWS::IAM::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent, :instrumentor, :instrumentor_name

      request_path 'fog/aws/requests/iam'
      request :add_user_to_group
      request :add_role_to_instance_profile
      request :create_access_key
      request :create_account_alias
      request :create_group
      request :create_instance_profile
      request :create_login_profile
      request :create_role
      request :create_user
      request :delete_access_key
      request :delete_account_alias
      request :delete_group
      request :delete_group_policy
      request :delete_instance_profile
      request :delete_login_profile
      request :delete_role
      request :delete_role_policy
      request :delete_server_certificate
      request :delete_signing_certificate
      request :delete_user
      request :delete_user_policy
      request :get_group
      request :get_group_policy
      request :get_instance_profile
      request :get_role_policy
      request :get_login_profile
      request :get_server_certificate
      request :get_role
      request :get_user
      request :get_user_policy
      request :list_access_keys
      request :list_account_aliases
      request :list_group_policies
      request :list_groups
      request :list_groups_for_user
      request :list_instance_profiles
      request :list_instance_profiles_for_role
      request :list_roles
      request :list_role_policies
      request :list_server_certificates
      request :list_signing_certificates
      request :list_user_policies
      request :list_users
      request :put_group_policy
      request :put_role_policy
      request :put_user_policy
      request :remove_role_from_instance_profile
      request :remove_user_from_group
      request :update_access_key
      request :update_group
      request :update_login_profile
      request :update_server_certificate
      request :update_signing_certificate
      request :update_user
      request :upload_server_certificate
      request :upload_signing_certificate

      model_path 'fog/aws/models/iam'
      model       :user
      collection  :users
      model       :policy
      collection  :policies
      model       :access_key
      collection  :access_keys
      model       :role
      collection  :roles


      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :owner_id => Fog::AWS::Mock.owner_id,
              :server_certificates => {},
              :access_keys => [{
                "Status" => "Active",
                "AccessKeyId" => key
              }],
              :users => Hash.new do |uhash, ukey|
                uhash[ukey] = {
                  :user_id     => Fog::AWS::Mock.key_id,
                  :path        => '/',
                  :arn         => "arn:aws:iam::#{Fog::AWS::Mock.owner_id}:user/#{ukey}",
                  :access_keys => [],
                  :created_at  => Time.now,
                  :policies    => {}
                }
              end,
              :groups => Hash.new do |ghash, gkey|
                ghash[gkey] = {
                  :group_id   => Fog::AWS::Mock.key_id,
                  :arn        => "arn:aws:iam::#{Fog::AWS::Mock.owner_id}:group/#{gkey}",
                  :members    => [],
                  :created_at  => Time.now,
                  :policies    => {}
                }
              end
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

          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @instrumentor           = options[:instrumentor]
          @instrumentor_name      = options[:instrumentor_name] || 'fog.aws.iam'
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

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(body, idempotent, parser)
            end
          else
            _request(body, idempotent, parser)
          end
        end

        def _request(body, idempotent, parser)
          @connection.request({
            :body       => body,
            :expects    => 200,
            :idempotent => idempotent,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :method     => 'POST',
            :parser     => parser
          })
        rescue Excon::Errors::HTTPStatusError => error
          match = Fog::AWS::Errors.match_error(error)
          raise if match.empty?
          raise case match[:code]
                when 'CertificateNotFound', 'NoSuchEntity'
                  Fog::AWS::IAM::NotFound.slurp(error, match[:message])
                when 'EntityAlreadyExists', 'KeyPairMismatch', 'LimitExceeded', 'MalformedCertificate', 'ValidationError'
                  Fog::AWS::IAM.const_get(match[:code]).slurp(error, match[:message])
                else
                  Fog::AWS::IAM::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
                end
        end

      end
    end
  end
end
