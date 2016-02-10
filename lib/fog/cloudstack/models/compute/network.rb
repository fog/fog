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

        # attribute :service,                 :aliases => 'service'
        attribute :network_domain,          :aliases => 'domain'
        attribute :physical_network_id,     :aliases => 'physicalnetworkid'
        attribute :restart_required,        :aliases => 'restartrequired'
        attribute :specify_ip_ranges,       :aliases => 'specifyipranges'
        attribute :canuse_for_deploy,       :aliases => 'canusefordeploy'
        attribute :is_persistent,           :aliases => 'ispersistent', :type => :boolean
        attribute :display_network,         :aliases => 'displaynetwork'
        attribute :is_default,              :aliases => 'isdefault', :type => :boolean

        # restart network - will return a job
        def restart(options={})
            response = service.restart_network( options.merge({'id'=> self.id}))
            service.jobs.new(response['restartnetworkresponse'])
        end

        # create a new network
        def save
          requires :display_text, :name, :network_offering_id, :zone_id

          options = {
            'displaytext'           => display_text,
            'name'                  => name,
            'zoneid'                => zone_id,
            'networkofferingid'     => network_offering_id
          }

          response = service.create_network(options)
          merge_attributes(response['createnetworkresponse']['network'])
        end

        # delete given network - will return a job
        def destroy(options={})
          response = service.delete_network(options.merge({'id'=> self.id}))
          service.jobs.new(response["deletenetworkresponse"])
        end

      end # Network
    end # Cloudstack
  end # Compute
end # Fog
