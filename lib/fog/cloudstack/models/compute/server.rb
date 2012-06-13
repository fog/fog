require 'fog/compute/models/server'

module Fog
  module Compute
    class Cloudstack
      class Server < Fog::Compute::Server
        identity  :id,                      :aliases => 'id'
        attribute :name
        attribute :account
        attribute :domain
        attribute :created
        attribute :state
        attribute :haenable
        attribute :memory
        attribute :display_name,            :aliases => 'displayname'
        attribute :domain_id,               :aliases => 'domainid'
        attribute :host_id,                 :aliases => 'hostid'
        attribute :host_name,               :aliases => 'hostname'
        attribute :project_id,              :aliases => 'projectid'
        attribute :zone_id,                 :aliases => 'zoneid'
        attribute :zone_name,               :aliases => 'zonename'
        attribute :image_id,                :aliases => ['templateid', :template_id]
        attribute :image_name,              :aliases => ['templatename', :template_name]
        attribute :templated_display_text,  :aliases => 'templatedisplaytext'
        attribute :password_enabled,        :aliases => 'passwordenabled'
        attribute :flavor_id,               :aliases => ['serviceofferingid', :service_offering_id]
        attribute :flavor_name,             :aliases => ['serviceofferingname', :service_offering_name]
        attribute :cpu_number,              :aliases => 'cpunumber'
        attribute :cpu_speed,               :aliases => 'cpuspeed'
        attribute :cpu_used,                :aliases => 'cpuused'
        attribute :network_kbs_read,        :aliases => 'networkkbsread'
        attribute :network_kbs_write,       :aliases => 'networkkbswrite'
        attribute :guest_os_id,             :aliases => 'guestosid'
        attribute :root_device_id,          :aliases => 'rootdeviceid'
        attribute :root_device_type,        :aliases => 'rootdevicetype'
        attribute :security_group,          :aliases => 'securitygroup'
        attribute :nics,                    :aliases => 'nic'

        attr_accessor :network_ids, :disk_offering_id, :ip_address, :ip_to_network_list

        def ready?
          state == 'Running'
        end

        def reboot
          requires :id
          data = connection.reboot_virtual_machine('id' => self.id) # FIXME: does this ever fail?
          job = Job.new(data["rebootvirtualmachineresponse"])
          job.connection= self.connection
          job
        end

        def save
          requires :image_id, :flavor_id, :zone_id

          options = {
            'templateid'        => image_id,
            'serviceofferingid' => flavor_id,
            'zoneid'            => zone_id,
            'networkids'        => network_ids,
            'diskofferingid'    => disk_offering_id,
            'displayname'       => display_name,
            'domainid'          => domain_id,
            'hostid'            => host_id,
            'ipaddress'         => ip_address,
            'iptonetworklist'   => ip_to_network_list,
            'projectid'         => project_id
          }

          options.merge!('networkids' => network_ids) if network_ids

          data = connection.deploy_virtual_machine(options)
          merge_attributes(data['deployvirtualmachineresponse'])
        end

        def addresses
          nics.map{|nic| Address.new(nic)}
        end

        def flavor
          connection.flavors.get(self.flavor_id)
        end

        def destroy
          requires :id
          connection.destroy_virtual_machine(:id => id)
          true
        end
      end # Server
    end # Cloudstack
  end # Compute
end # Fog
