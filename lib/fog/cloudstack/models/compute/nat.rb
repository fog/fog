module Fog
  module Compute
    class Cloudstack
      class Nat < Fog::Model
        identity  :id,                                            :aliases => 'id'
        attribute :ip_address_id,                                 :aliases => 'ipaddressid'
        attribute :virtual_machine_id,                            :aliases => 'virtualmachineid'
        attribute :network_id,                                    :aliases => 'networkid'

        def enable
          requires :ip_address_id
          requires :virtual_machine_id

          options = {
              'ipaddressid'        => self.ip_address_id,
              'virtualmachineid'     => self.virtual_machine_id,
              'networkid' => self.network_id,
          }
          data = connection.enable_static_nat(options)
        end

        def disable
          requires :ip_address_id
          data = connection.disable_static_nat(options={'ipaddressid' => self.ip_address_id})
          connection.jobs.new(data["disablestaticnatresponse"])
        end

      end # Nat
    end # Cloudstack
  end # Compute
end # Fog