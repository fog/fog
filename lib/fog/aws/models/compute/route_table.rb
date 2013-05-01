require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class RouteTable < Fog::Model

        identity  :route_table_id,              :aliases => 'routeTableId'
        attribute :vpc_id,                      :aliases => 'vpcId'
        attribute :route_set,                   :aliases => 'routeSet'
        attribute :association_set,             :aliases => 'associationSet'
        attribute :propagating_vgw_set,         :aliases => 'propagatingVgwSet'
        attribute :tag_set,                     :aliases => 'tagSet'


        # Removes an existing route_table
        #
        # route_table.destroy
        #
        # ==== Returns
        #
        # True or false depending on the result
        #

        def destroy
          requires :route_table_id

          service.delete_route_table(route_table_id)
          true
        end

        # Create a route_table
        #
        #  >> g = AWS.route_tables.new(:vpc_id => "vpc-someId")
        #  >> g.save
        #
        # == Returns:
        #
        # requestId and a routeTable object
        #

        def save
          requires :vpc_id
          data = service.create_route_table(vpc_id).body['routeTableSet'].first
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true

          true
        end

      end
    end
  end
end
