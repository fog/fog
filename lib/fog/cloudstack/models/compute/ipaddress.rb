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

          data = service.associate_ip_address(options={'networkid' => self.associated_network_id})
          merge_attributes(data['associateipaddressresponse'])
          service.jobs.new(data["associateipaddressresponse"])
        end

        def disassociate
          requires :id
          data = service.disassociate_ip_address(options={'id' => self.id}) if (id != nil)
        end

      end # Ipaddress
    end # Cloudstack
  end # Compute
end # Fog
