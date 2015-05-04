module Fog
  module Compute
    class Cloudstack
      class PublicIpAddress < Fog::Model
        identity  :id

        attribute :account
        attribute :allocated,               :type => :time
        attribute :associated_network_id,                      :aliases => 'associatednetworkid'
        attribute :associated_network_name,                    :aliases => 'associatednetworkname'
        attribute :domain
        attribute :domain_id,                                  :aliases => 'domainid'
        attribute :for_virtual_network,     :type => :boolean, :aliases => 'forvirtualnetwork'
        attribute :ip_address,                                 :aliases => 'ipaddress'
        attribute :is_portable,             :type => :boolean, :aliases => 'isportable'
        attribute :is_source_nat,           :type => :boolean, :aliases => 'issourcenat'
        attribute :is_static_nat,           :type => :boolean, :aliases => 'isstaticnat'
        attribute :is_system,               :type => :boolean, :aliases => 'issystem'
        attribute :network_id,              :type => :boolean, :aliases => 'networkid'
        attribute :physical_network_id,                        :aliases => 'physicalnetworkid'
        attribute :project
        attribute :project_id,                                 :aliases => 'projectid'
        attribute :purpose
        attribute :state
        attribute :server_display_name,                        :aliases => 'virtualmachinedisplayname'
        attribute :server_id,                                  :aliases => 'virtualmachineid'
        attribute :server_name,                                :aliases => 'virtualmachinename'
        attribute :vlan_id,                                    :aliases => 'vlanid'
        attribute :vlan_name,                                  :aliases => 'vlanname'
        attribute :server_ip_address,                          :aliases => 'vmipaddress'
        attribute :vpc_id,                                     :aliases => 'vpcid'
        attribute :zone_id,                                    :aliases => 'zoneid'
        attribute :zone_name,                                  :aliases => 'zonename'
        attribute :tags,                    :type => :array
        attribute :job_id,                                     :aliases => 'jobid'   # only on associate

        def initialize(attributes = {})
          # assign server first to prevent race condition with persisted?
          self.server = attributes.delete(:server)
          super
        end

        def ready?
          state == 'Allocated'
        end

        def destroy
          requires :identity
          service.disassociate_ip_address('id' => id)
          true
        end

        def server=(new_server)
          @server = new_server
          if persisted?
            if !server_id.nil? && (new_server.nil? || server_id != new_server.id)
              service.disable_static_nat('ipaddressid' => id)
              self.server_display_name = nil
              self.server_id = nil
              self.server_name = nil
              self.server_ip_address = nil
              self.is_static_nat = false
            end
            unless new_server.nil?
              service.enable_static_nat(
                'ipaddressid' => id, 'virtualmachineid' => new_server.id)
            end
          end
        end

        def server
          service.servers.get(server_id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          options = {
            'account'    => account,
            'domainid'   => domain_id,
            'isportable' => is_portable,
            'networkid'  => network_id,
            'projectid'  => project_id,
            'vpcid'      => vpc_id,
            'zoneid'     => zone_id,
          }
          response = service.associate_ip_address(options)
          merge_attributes(response['associateipaddressresponse'])
          if @server
            self.server = @server
          end
          true
        end
      end
    end
  end
end
