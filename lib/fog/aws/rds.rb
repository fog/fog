require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class RDS < Fog::Service

      class IdentifierTaken < Fog::Errors::Error; end
      
      class AuthorizationAlreadyExists < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/rds'

      request :create_db_instance
      request :modify_db_instance
      request :describe_db_instances
      request :delete_db_instance
      request :reboot_db_instance
      request :create_db_instance_read_replica
      request :describe_db_engine_versions
      request :describe_db_reserved_instances

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

      class Mock

        def self.data
          @data ||= Hash.new do |hash, region|
            owner_id = Fog::AWS::Mock.owner_id
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :servers => {},
                :security_groups => {},
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
        
          @aws_access_key_id = options[:aws_access_key_id]
        
          @region = options[:region] || 'us-east-1'
        
          unless ['ap-northeast-1', 'ap-southeast-1', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2'].include?(@region)
            raise ArgumentError, "Unknown region: #{@region.inspect}"
          end
        
        end
        
        def data
          self.class.data[@region][@aws_access_key_id]
        end
        
        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end
        
        

      end

      class Real

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
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @connection_options     = options[:connection_options] || {}
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)

          options[:region] ||= 'us-east-1'
          @host = options[:host] || "rds.#{options[:region]}.amazonaws.com"
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
              :version            => '2011-04-01' #'2010-07-28'
            }
          )

          begin
            response = @connection.request({
              :body       => body,
              :expects    => 200,
              :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
              :idempotent => idempotent,
              :host       => @host,
              :method     => 'POST',
              :parser     => parser
            })
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.message.match(/<Code>(.*)<\/Code>[\s\\\w]+<Message>(.*)<\/Message>/m)
              case match[1].split('.').last
              when 'DBInstanceNotFound', 'DBParameterGroupNotFound', 'DBSnapshotNotFound', 'DBSecurityGroupNotFound'
                raise Fog::AWS::RDS::NotFound.slurp(error, match[2])
              when 'DBParameterGroupAlreadyExists'
                raise Fog::AWS::RDS::IdentifierTaken.slurp(error, match[2])
              when 'AuthorizationAlreadyExists'
                raise Fog::AWS::RDS::AuthorizationAlreadyExists.slurp(error, match[2])
              else
                raise
              end
            else
              raise
            end
          end

          response
        end

      end
    end
  end
end
