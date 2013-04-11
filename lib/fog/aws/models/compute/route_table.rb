require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class RouteTable < Fog::Model

        identity :id,                :aliases => 'routeTableId'

        attribute :state
        attribute :vpc_id,           :aliases => 'vpcId'
        attribute :routes,           :aliases => 'routeSet'
        attribute :associations,     :aliases => 'associationSet'
        attribute :tags,             :aliases => 'tagSet'
        

        def initialize(attributes={})
          super
        end

        # Removes an existing vpc
        #
        # vpc.destroy
        #
        # ==== Returns
        #
        # True or false depending on the result
        #

        def destroy
          requires :id

          service.delete_route_table (id)
          true
        end

        # Create a vpc
        #
        # >> g = AWS.vpcs.new(:cidr_block => "10.1.2.0/24")
        # >> g.save
        #
        # == Returns:
        #
        # True or an exception depending on the result. Keep in mind that this *creates* a new vpc.
        # As such, it yields an InvalidGroup.Duplicate exception if you attempt to save an existing vpc.
        #

        def save
          requires :vpc_id

          data = service.create_route_table(vpc_id).body['routeTableSet'].first
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true
        end
        
        
         private

          def associationSet=(new_association_set)
            merge_attributes(new_association_set.first || {})
          end
          
          def routeSet=(new_route_set)
            merge_attributes(new_route_set || {})
          end

      end

    end
  end
end
