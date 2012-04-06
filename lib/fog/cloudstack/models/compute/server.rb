require 'fog/compute/models/server'

module Fog
  module Compute
    class Cloudstack

      class Server < Fog::Compute::Server
        extend Fog::Deprecation

        identity :id, :aliases => 'instanceId'

        attribute :name,                  :aliases => 'name'
        attribute :display_name,          :aliases => 'displayname'
        attribute :account
        attribute :domain_id,             :aliases => 'domainid'
        attribute :domain
        attribute :created
        attribute :state
        attribute :haenable
        attribute :zone_id,               :aliases => 'zoneid'
        attribute :zone_name,             :aliases => 'zonename'
        attribute :host_id,               :aliases => 'hostid'
        attribute :host_name,             :aliases => 'hostname'
        attribute :image_id,              :aliases => 'templateid'
        attribute :image_name,            :aliases => 'templatename'
        attribute :image_display_text,    :aliases => 'templatedisplaytext'
        attribute :passwordenabled
        attribute :flavor_id,             :aliases => 'serviceofferingid'
        attribute :flavor_name,           :aliases => 'serviceofferingname'
        attribute :cpu_number,            :aliases => 'cpunumber'
        attribute :cpu_speed,             :aliases => 'cpuspeed'
        attribute :memory
        attribute :cpu_used,              :aliases => 'cpuused'
        attribute :network_kbs_read,      :aliases => 'networkkbsread'
        attribute :network_kbs_write,     :aliases => 'networkkbswrite'
        attribute :guest_os_id,           :aliases => 'guestosid'
        attribute :root_device_id,        :aliases => 'rootdeviceid'
        attribute :root_device_type,      :aliases => 'rootdevicetype'
        attribute :public_ip_address,     :aliases => 'nic'
        attribute :security_group_id,     :aliases => 'securitygroup'
        attribute :hypervisor
        attribute :group_id,              :aliases => 'groupid'
        attribute :group_name,            :aliases => 'group'
        attribute :iso_id,                :aliases => 'isoid'
        attribute :iso_name,              :aliases => 'isoname'
        attribute :iso_display_text,      :aliases => 'isodisplaytext'
        attribute :project_id,            :aliases => 'projectid'
        attribute :project_name,          :aliases => 'project'

        def initialize(attributes={})
          super
        end

        def destroy
          requires :id

          connection.destroy_virtual_machine({'id' => id})

          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :image_id

          options = {
            'serviceOfferingId' => flavor_id,
            'templateId' => image_id,
            'zoneId' => zone_id,
            'name' => name,
            'keypair' => key_name,
            'group' => group_name
          }
          options.delete_if {|key, value| value.nil?}

          data = connection.deploy_virtual_machine(options).body
          self.id = data['id']

          true
        end

        private

        def public_ip_address=(value)
          attributes[:public_ip_address] = value[0]['ipaddress']
        end

        def security_group_id=(value)
          attributes[:security_group_id] = value[0]['id']
        end

      end
    end
  end
end
