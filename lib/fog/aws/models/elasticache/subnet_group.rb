require 'fog/core/model'

module Fog
  module AWS
    class Elasticache

      class SubnetGroup < Fog::Model

        identity   :id, :aliases => ['CacheSubnetGroupName', :name]
        attribute  :description, :aliases => 'CacheSubnetGroupDescription'
        attribute  :status, :aliases => 'SubnetGroupStatus'
        attribute  :vpc_id, :aliases => 'VpcId'
        attribute  :subnet_ids, :aliases => 'Subnets'

        def destroy
          requires :id
          service.delete_cache_subnet_group(id)
          true
        end

      end
    end
  end
end
