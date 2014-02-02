require 'fog/aws/core'

module Fog
  module AWS
    class RDS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      class IdentifierTaken < Fog::Errors::Error; end

      class AuthorizationAlreadyExists < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :version

      request_path 'fog/aws/requests/rds'
      request :describe_events
      request :create_db_instance
      request :modify_db_instance
      request :describe_db_instances
      request :delete_db_instance
      request :reboot_db_instance
      request :create_db_instance_read_replica
      request :describe_db_engine_versions
      request :describe_db_reserved_instances

      request :add_tags_to_resource
      request :list_tags_for_resource
      request :remove_tags_from_resource

      request :describe_db_snapshots
      request :create_db_snapshot
      request :delete_db_snapshot

      request :create_db_parameter_group
      request :delete_db_parameter_group
      request :modify_db_parameter_group
      request :describe_db_parameter_groups

      request :describe_db_security_groups
      request :create_db_security_group
      request :delete_db_security_group
      request :authorize_db_security_group_ingress
      request :revoke_db_security_group_ingress

      request :describe_db_parameters

      request :restore_db_instance_from_db_snapshot
      request :restore_db_instance_to_point_in_time

      request :create_db_subnet_group
      request :describe_db_subnet_groups
      request :delete_db_subnet_group
      # TODO: :modify_db_subnet_group

      request :describe_orderable_db_instance_options

      request :describe_db_log_files
      request :download_db_logfile_portion

      model_path 'fog/aws/models/rds'
      model       :server
      collection  :servers

      model       :snapshot
      collection  :snapshots

      model       :parameter_group
      collection  :parameter_groups

      model       :parameter
      collection  :parameters

      model       :security_group
      collection  :security_groups

      model       :subnet_group
      collection  :subnet_groups

      model       :instance_option
      collection  :instance_options

      model       :log_file
      collection  :log_files

      class Mock

        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :servers => {},
                :security_groups => {},
                :subnet_groups => {},
                :snapshots => {},
                :parameter_groups => {"default.mysql5.1" => { "DBParameterGroupFamily"=>"mysql5.1",
                                                              "Description"=>"Default parameter group for mysql5.1",
                                                              "DBParameterGroupName"=>"default.mysql5.1"
                                                            },
                                      "default.mysql5.5" => {"DBParameterGroupFamily"=>"mysql5.5",
                                                            "Description"=>"Default parameter group for mysql5.5",
                                                            "DBParameterGroupName"=>"default.mysql5.5"
                                                            }
                                      }
                                 }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})

          @use_iam_profile = options[:use_iam_profile]
          @region = options[:region] || 'us-east-1'

          unless ['ap-northeast-1', 'ap-southeast-1', 'ap-southeast-2', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'sa-east-1'].include?(@region)
            raise ArgumentError, "Unknown region: #{@region.inspect}"
          end

        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end

        def setup_credentials(options)
          @aws_access_key_id = options[:aws_access_key_id]
        end

      end

      class Real
        attr_reader :region

        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to ELB
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   elb = ELB.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance, 'eu-west-1', 'us-east-1' and etc.
        #
        # ==== Returns
        # * ELB object with connection to AWS.
        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)
          @connection_options     = options[:connection_options] || {}

          @region     = options[:region]      || 'us-east-1'
          @host       = options[:host]        || "rds.#{@region}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
          @version    = options[:version] || '2013-05-15'
        end

        def owner_id
          @owner_id ||= security_groups.get('default').owner_id
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

          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)
        end

        def request(params)
          refresh_credentials_if_expired

          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = Fog::AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :aws_session_token  => @aws_session_token,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => @version
            }
          )

          begin
            @connection.request({
              :body       => body,
              :expects    => 200,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :idempotent => idempotent,
              :method     => 'POST',
              :parser     => parser
            })
          rescue Excon::Errors::HTTPStatusError => error
            match = Fog::AWS::Errors.match_error(error)
            if match.empty?
              case error.message
              when 'Not Found'
                raise Fog::AWS::RDS::NotFound.slurp(error, 'RDS Instance not found')
              else
                raise
              end
            else
              raise case match[:code]
                    when 'DBInstanceNotFound', 'DBParameterGroupNotFound', 'DBSnapshotNotFound', 'DBSecurityGroupNotFound'
                      Fog::AWS::RDS::NotFound.slurp(error, match[:message])
                    when 'DBParameterGroupAlreadyExists'
                      Fog::AWS::RDS::IdentifierTaken.slurp(error, match[:message])
                    when 'AuthorizationAlreadyExists'
                      Fog::AWS::RDS::AuthorizationAlreadyExists.slurp(error, match[:message])
                    else
                      Fog::AWS::RDS::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
                    end
            end
          end
        end

      end
    end
  end
end
