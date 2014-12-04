module Fog
  module Compute
    class Cloudstack
      class Network < Fog::Model
        identity  :id,                      :aliases => 'id'
        attribute :name,                    :aliases => 'name'
        attribute :display_text,            :aliases => 'displaytext'

        attribute :broadcast_domain_type,   :aliases => 'broadcastdomaintype'
        attribute :traffic_type,            :aliases => 'traffictype'
        attribute :gateway,                 :aliases => 'gateway'
        attribute :cidr,                    :aliases => 'cidr'
        attribute :zone_id,                 :aliases => 'zoneid'
        attribute :zone_name,               :aliases => 'zonename'

        attribute :network_offering_id,            :aliases => 'networkofferingid'
        attribute :network_offering_name,          :aliases => 'networkofferingname'
        attribute :network_offering_display_text,  :aliases => 'networkofferingdisplaytext'
        attribute :network_offering_conserve_mode, :aliases => 'networkofferingconservemode'
        attribute :network_offering_availability,  :aliases => 'networkofferingavailability'
        attribute :is_system,               :aliases => 'issystem', :type => :boolean
        attribute :state,                   :aliases => 'state'

        attribute :related,                 :aliases => 'related'
        attribute :dns1,                    :aliases => 'dns1'
        attribute :dns2,                    :aliases => 'dns2'
        attribute :type,                    :aliases => 'type'
        attribute :acl_type,                :aliases => 'acltype'
        attribute :project_id,              :aliases => 'projectid'
        attribute :domain_id,               :aliases => 'domainid'
        attribute :domain,                  :aliases => 'domain'

        attribute :service,                 :aliases => 'service'
        attribute :network_domain,          :aliases => 'domain'
        attribute :physical_network_id,     :aliases => 'physicalnetworkid'
        attribute :restart_required,        :aliases => 'restartrequired'
        attribute :specify_ip_ranges,       :aliases => 'specifyipranges'
        attribute :canuse_for_deploy,       :aliases => 'canusefordeploy'
        attribute :is_persistent,           :aliases => 'ispersistent', :type => :boolean
        attribute :display_network,         :aliases => 'displaynetwork'

        def restart
            # AN - need to test
            response = @connection.restart_network( self.id)
            # there are a bunch of fields
            # should be mapped back to attributes
        end

        def save
          raise Fog::Errors::Error.new('Creating a network is not supported')
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying a network is not supported')

          # response = @connection.delete_network( {'id' => @self.id })
          # returns success & displaytext
        end

      end # Network
    end # Cloudstack
  end # Compute
end # Fog
