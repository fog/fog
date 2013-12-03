require 'fog/core/model'

module Fog
  module AWS
    class RDS

      class SubnetGroup < Fog::Model

        identity   :id, :aliases => ['DBSubnetGroupName', :name]
        attribute  :description, :aliases => 'DBSubnetGroupDescription'
        attribute  :status, :aliases => 'SubnetGroupStatus'
        attribute  :vpc_id, :aliases => 'VpcId'
        attribute  :subnet_ids, :aliases => 'Subnets'

        # TODO: ready?, save, destroy

      end
    end
  end
end
