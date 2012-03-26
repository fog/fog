require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class Subnet < Fog::Model

        identity  :subnet_id,                   :aliases => 'subnetId'
        attribute :state     
        attribute :vpc_id,                      :aliases => 'vpcId'
        attribute :cidr_block,                  :aliases => 'cidrBlock'
        attribute :available_ip_address_count,  :aliases => 'availableIpAddressCount'
        attribute :availability_zone,           :aliases => 'availabilityZone'
        attribute :tag_set,                     :aliases => 'tagSet'


        # Removes an existing subnet
        #
        # subnet.destroy
        #
        # ==== Returns
        #
        # True or false depending on the result
        #

        def destroy
          requires :subnet_id

          connection.delete_subnet(subnet_id)
          true
        end

        # Create a subnet
        #
        #  >> g = AWS.subnets.new(:vpc_id => "vpc-someId", :cidr_block => "10.0.0.0/24")
        #  >> g.save
        #
        # == Returns:
        #
        # requestId and a subnetSet object
        #

        def save
          requires :vpc_id, :cidr_block
          data = connection.create_subnet(vpc_id, cidr_block).body['subnetSet'].first
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true

          true
        end

      end
    end
  end
end
