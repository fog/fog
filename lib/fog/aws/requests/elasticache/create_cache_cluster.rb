module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/single_cache_cluster'
        # creates a cache cluster
        #
        # === Required Parameters
        # * id <~String> - A unique cluster ID - 20 characters max.
        # === Optional Parameters
        # * options <~Hash> - All optional parameters should be set in this Hash:
        #   * :node_type <~String> - The size (flavor) of the cache Nodes
        #   * :security_group_names <~Array> - Array of Elasticache::SecurityGroup names
        #   * :num_nodes <~Integer> - The number of nodes in the Cluster
        #   * :auto_minor_version_upgrade <~TrueFalseClass>
        #   * :parameter_group_name <~String> - Name of the Cluster's ParameterGroup
        #   * :engine <~String> - The Cluster's caching software (memcached)
        #   * :engine_version <~String> - The Cluster's caching software version
        #   * :notification_topic_arn <~String> - Amazon SNS Resource Name
        #   * :port <~Integer> - The memcached port number
        #   * :preferred_availablility_zone <~String>
        #   * :preferred_maintenance_window <~String>
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def create_cache_cluster(id, options = {})
          # Construct Cache Security Group parameters in the format:
          #   CacheSecurityGroupNames.member.N => "security_group_name"
          group_names = options[:security_group_names] || ['default']
          sec_group_params = group_names.inject({}) do |group_hash, name|
            index = group_names.index(name) + 1
            group_hash["CacheSecurityGroupNames.member.#{index}"] = name
            group_hash
          end
          # Merge the Cache Security Group parameters with the normal options
          request(sec_group_params.merge(
            'Action'          => 'CreateCacheCluster',
            'CacheClusterId'  => id.strip,
            'CacheNodeType'   => options[:node_type]  || 'cache.m1.large',
            'Engine'          => options[:engine]     || 'memcached',
            'NumCacheNodes'   => options[:num_nodes]  || 1,
            'AutoMinorVersionUpgrade'     => options[:auto_minor_version_upgrade],
            'CacheParameterGroupName'     => options[:parameter_group_name],
            'EngineVersion'               => options[:engine_version],
            'NotificationTopicArn'        => (options[:notification_topic_arn]).strip,
            'Port'                        => options[:port],
            'PreferredAvailabilityZone'   => options[:preferred_availablility_zone],
            'PreferredMaintenanceWindow'  => options[:preferred_maintenance_window],
            :parser => Fog::Parsers::AWS::Elasticache::SingleCacheCluster.new
          ))
        end
      end

      class Mock
        def create_cache_cluster(id, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
