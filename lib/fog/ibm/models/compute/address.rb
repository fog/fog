require 'fog/core/model'

module Fog
  module Compute
    class IBM
      class Address < Fog::Model

        identity :id

        attribute :type
        attribute :location
        attribute :ip
        attribute :state
        attribute :instance_id, :aliases => 'instanceId'
        attribute :offering_id, :aliases => 'offeringId'
        attribute :vlan_id, :aliases => 'vlanId'
        attribute :hostname
        attribute :mode
        attribute :owner

        def initialize(new_attributes={})
          super(new_attributes)
          self.offering_id ||= '20001223'
          self.location ||= '82'
        end

        def save
          requires :offering_id, :location
          data = connection.create_address(location, offering_id,
                                           :vlan_id => vlan_id,
                                           :ip => ip)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          connection.delete_address(id).body['success']
        end
      end
    end
  end
end
