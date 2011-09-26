module Fog
  module AWS
    class Elasticache < Fog::Service

      class IdentifierTaken < Fog::Errors::Error; end
      class InvalidInstance < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/elasticache'

      request :create_cache_cluster
      request :delete_cache_cluster
      request :describe_cache_clusters
      request :modify_cache_cluster
      request :reboot_cache_cluster

      request :create_cache_parameter_group
      request :delete_cache_parameter_group
      request :describe_cache_parameter_groups
      request :modify_cache_parameter_group
      request :reset_cache_parameter_group
      request :describe_engine_default_parameters
      request :describe_cache_parameters

      request :create_cache_security_group
      request :delete_cache_security_group
      request :describe_cache_security_groups
      request :authorize_cache_security_group_ingress
      request :revoke_cache_security_group_ingress

      request :describe_events

      model_path 'fog/aws/models/elasticache'
      model :cluster
      collection :clusters
      model :security_group
      collection :security_groups
      model :parameter_group
      collection :parameter_groups

      class Mock
        def initalize(options={})
          Fog::Mock.not_implemented
        end
      end

      class Real

        def initialize(options={})
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)

          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'us-east-1'
            'elasticache.us-east-1.amazonaws.com'
            #TODO: Support other regions
          else
            raise ArgumentError, "Unknown region: #{options[:region].inspect}"
          end
          @path       = options[:path]      || '/'
          @port       = options[:port]      || 443
          @scheme     = options[:scheme]    || 'https'
          @connection = Fog::Connection.new(
            "#{@scheme}://#{@host}:#{@port}#{@path}", options[:persistent]
          )
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
            :version            => '2011-07-15'
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
            if match = error.message.match(/<Code>(.*)<\/Code>/m)
              case match[1]
              when 'CacheSecurityGroupNotFound', 'CacheParameterGroupNotFound',
                'CacheClusterNotFound'
                raise Fog::AWS::Elasticache::NotFound
              when 'CacheSecurityGroupAlreadyExists'
                raise Fog::AWS::Elasticache::IdentifierTaken
              when 'InvalidParameterValue'
                raise Fog::AWS::Elasticache::InvalidInstance
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
