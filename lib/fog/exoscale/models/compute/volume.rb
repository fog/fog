module Fog
  module Compute
    class Exoscale
      class Volume < Fog::Model
        identity  :id,                         :aliases => 'id'

        attribute :name,                       :aliases => 'name'
        attribute :zone_id,                    :aliases => 'zoneid'
        attribute :zone_name,                  :aliases => 'zonename'
        attribute :type,                       :aliases => 'type'
        attribute :size,                       :aliases => 'size'
        attribute :created,                    :aliases => 'created'
        attribute :state,                      :aliases => 'state'
        attribute :account,                    :aliases => 'account'
        attribute :domain_id,                  :aliases => 'domainid'
        attribute :domain,                     :aliases => 'domain'
        attribute :storage_type,               :aliases => 'storagetype'
        attribute :hypervisor,                 :aliases => 'hypervisor'
        attribute :disk_offering_id,           :aliases => 'diskofferingid'
        attribute :disk_offering_name,         :aliases => 'diskofferingname'
        attribute :disk_offering_display_text, :aliases => 'diskofferingdisplaytext'
        attribute :storage,                    :aliases => 'storage'
        attribute :destroyed,                  :aliases => 'destroyed'
        attribute :is_extractable,             :aliases => 'isextractable', :type => :boolean
        attribute :server_id,                  :aliases => 'virtualmachineid'
        attribute :server_name,                :aliases => 'vmname'
        attribute :server_display_name,        :aliases => 'vmdisplayname'

        attr_accessor :snapshot_id, :project_id

        def save
          raise Fog::Errors::Error.new('Creating a volume is not supported')
        end

        def ready?
          state == 'Allocated' || state == 'Ready'
        end

        def flavor
          service.disk_offerings.get(self.disk_offering_id)
        end
        alias_method :disk_offering, :flavor

        def server
          if server_id
            service.servers.get(server_id)
          end
        end

        def reload
          raise Fog::Errors::Error.new('Reloading a volume is not supported')
        end

        def attach(instance_or_id, mountpoint=nil)
          raise Fog::Errors::Error.new('Attaching a volume is not supported')
        end

        def detach
          raise Fog::Errors::Error.new('Detaching a volume is not supported')
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying a volume is not supported')
        end
      end # Volume
    end # Exoscale
  end # Compute
end # Fog
