module Fog
  module Compute
    class Cloudstack
      class Ipaddress < Fog::Model
        identity  :id,                                            :aliases => 'id'
        attribute :virtual_machine_id,                            :aliases => 'virtualmachineid'
        attribute :network_id,                                    :aliases => 'networkid'
        attribute :ip_address,                                    :aliases => 'ipaddress'
        attribute :associated_network_id,                         :aliases => 'associatednetworkid'
        def associate
          requires :network_id

          data = connection.acquire_ip_address(options={'networkid' => self.network_id})
          merge_attributes(data['associateipaddressresponse'])
          connection.jobs.new(data["associateipaddressresponse"])
        end

        def disassociate
          requires :id
          data = connection.disassociate_ip_address(options={'id' => self.id}) if (id != nil)
        end

      end # Ipaddress
    end # Cloudstack
  end # Compute
end # Fog