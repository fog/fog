require 'fog/compute/models/server'

module Fog
  module Compute
    class Cloudstack
      class Server < Fog::Compute::Server
        extend Fog::Deprecation
        identity  :id,                      :aliases => 'id'
        attribute :name
        attribute :display_name,            :aliases => 'displayname'
        attribute :account
        attribute :domain_id,               :aliases => 'domainid'
        attribute :domain
        attribute :created
        attribute :state
        attribute :haenable
        attribute :zone_id,                 :aliases => 'zoneid'
        attribute :zone_name,               :aliases => 'zonename'
        attribute :template_id,             :aliases => 'templateid'
        attribute :template_name,           :aliases => 'templatename'
        attribute :templated_display_text,  :aliases => 'templatedisplaytext'
        attribute :password_enabled,        :aliases => 'passwordenabled'
        attribute :service_offering_id,     :aliases => 'serviceofferingid'
        attribute :service_offering_name,   :aliases => 'serviceofferingname'
        attribute :cpu_number,              :aliases => 'cpunumber'
        attribute :cpu_speed,               :aliases => 'cpuspeed'
        attribute :memory
        attribute :cpu_used,                :aliases => 'cpuused'
        attribute :network_kbs_read,        :aliases => 'networkkbsread'
        attribute :network_kbs_write,       :aliases => 'networkkbswrite'
        attribute :guest_os_id,             :aliases => 'guestosid'
        attribute :root_device_id,          :aliases => 'rootdeviceid'
        attribute :root_device_type,        :aliases => 'rootdevicetype'
        attribute :security_group,          :aliases => 'securitygroup'
        attribute :nics,                    :aliases => 'nic'

        attr_accessor :network_ids

        def ready?
          true
        end

        def save
          requires :template_id, :service_offering_id, :zone_id
          data = connection.deploy_virtual_machine(
            :template_id => template_id,
            :service_offering_id => service_offering_id,
            :zone_id => zone_id,
            :network_ids => network_ids
          )
          merge_attributes(data['deployvirtualmachineresponse'])
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
