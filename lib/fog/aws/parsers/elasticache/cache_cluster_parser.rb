module Fog
  module Parsers
    module AWS
      module Elasticache
        require 'fog/aws/parsers/elasticache/base'

        class CacheClusterParser < Base

          def reset
            super
            reset_cache_cluster
          end

          def reset_cache_cluster
            @cache_cluster = {
              'CacheSecurityGroups' => [],
              'CacheNodes' => [],
              'CacheParameterGroup' => {}
            }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'CacheSecurityGroup'; then @security_group = {}
            when 'CacheNode'; then @cache_node = {}
            end

          end

          def end_element(name)
            case name
            when 'AutoMinorVersionUpgrade', 'CacheClusterId',
              'CacheClusterStatus', 'CacheNodeType', 'Engine', 'EngineVersion',
              'PreferredAvailabilityZone', 'PreferredMaintenanceWindow'
              @cache_cluster[name] = value
            when 'NumCacheNodes'
              @cache_cluster[name] = value.to_i
            when 'CacheClusterCreateTime'
              @cache_cluster[name] = DateTime.parse(value)
            when 'CacheSecurityGroup'
              @cache_cluster["#{name}s"] << @security_group unless @security_group.empty?
            when 'CacheSecurityGroupName', 'Status'
              @security_group[name] = value
            when 'CacheNode'
              @cache_cluster["#{name}s"] << @cache_node unless @cache_node.empty?
            when 'CacheNodeCreateTime', 'CacheNodeId', 'CacheNodeStatus',
              'Address', 'ParameterGroupStatus', 'Port'
              @cache_node[name] = value ? value.strip : name
            when 'CacheNodeIdsToReboots', 'CacheParameterGroupName', 'ParameterApplyStatus'
              @cache_cluster['CacheParameterGroup'][name] = value
            else
              super
            end
          end
        end
      end
    end
  end
end

