module Fog
  module Compute
    class Cloudstack
      class PortForwardingRule < Fog::Model
        identity  :id,                            :aliases => 'id'

        attribute :private_port,                  :aliases => 'privateport'
        attribute :private_end_port,              :aliases => 'privateendport'
        attribute :protocol,                      :aliases => 'protocol'
        attribute :public_port,                   :aliases => 'publicport'
        attribute :public_end_port,               :aliases => 'publicendport'
        attribute :virtual_machine_id,            :aliases => 'virtualmachineid'
        attribute :virtual_machine_name,          :aliases => 'virtualmachinename'
        attribute :virtual_machine_display_name,  :aliases => 'virtualmachinedisplayname'
        attribute :ip_address_id,                 :aliases => 'ipaddressid'
        attribute :ip_address,                    :aliases => 'ipaddress'
        attribute :state,                         :aliases => 'state'
        attribute :cidr_list,                     :aliases => 'cidrlist'
        attribute :vm_guest_ip,                   :aliases => 'vmguestip'
        attribute :network_id,                    :aliases => 'networkid'
        attribute :tags,                          :type => :array

        def save
          requires :ip_address_id, :private_port, :public_port, :protocol, :virtual_machine_id

          options = {
            'ipaddressid'       => ip_address_id,
            'privateport'       => private_port,
            'privateendport'    => private_end_port,
            'protocol'          => protocol,
            'publicport'        => public_port,
            'publicendport'     => public_end_port,
            'virtualmachineid'  => virtual_machine_id,
            'cidrlist'          => cidr_list,
            'network_id'        => network_id
          }

          response = service.create_port_forwarding_rule(options)
          merge_attributes(response['createportforwardingruleresponse'])
        end

        def destroy
          # requires :id

          response = service.delete_port_forwarding_rule('id' => self.id )
          job = service.jobs.new(response['deleteportforwardingruleresponse'])
        end

      end
    end
  end
end
