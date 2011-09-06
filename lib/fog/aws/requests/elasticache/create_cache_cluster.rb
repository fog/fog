module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/single_cache_cluster'
        # creates a cache cluster
        #
        # === Required Parameters
        # * options <~Hash> - The all parameters should be set in this Hash:
        #   * :cluster_id <~String> - The name of the Cache Cluster
        #   * :node_type <~String> - The size (flavor) of the cache Nodes
        #   * :security_group_names <~Array> - Array of Elasticache::SecurityGroup names
        #   * :num_nodes <~Integer> - The number of nodes in the Cluster
        # === Optional Parameters (also set in the options hash)
        #   * :auto_minor_version_upgrade <~TrueFalseClass>
        #   * :parameter_group_name <~String> - Name of the Cluster's ParameterGroup
        #   * :engine <~String> - The Cluster's caching software (memcached)
        #   * :engine_version <~String> - The Cluster's caching software version
        #   * :notification_topic_arn <~String> - Amazon SNS Resource Name
        #   * :cluster_id <~String> - The name of the Cache Cluster
        #   * :port <~Integer> - The memcached port number
        #   * :preferred_availablility_zone <~String>
        #   * :preferred_maintenance_window <~String>
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def create_cache_cluster(options)
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
            'CacheClusterId'  => options[:cluster_id],
            'CacheNodeType'   => options[:node_type]  || 'cache.m1.large',
            'Engine'          => options[:engine]     || 'memcached',
            'NumCacheNodes'   => options[:num_nodes]  || 1 ,
            :parser => Fog::Parsers::AWS::Elasticache::SingleCacheCluster.new
          ))
        end
      end

      class Mock
        def create_cache_cluster(options)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
