module Fog
  module Compute
    class Cloudstack
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
        attribute :job_id,                     :aliases => 'jobid'   # only on create

        attr_accessor :snapshot_id, :project_id

        def save
          requires :name, :disk_offering_id, :zone_id

          options = {
            'size'           => size,
            'name'           => name,
            'diskofferingid' => disk_offering_id,
            'zoneid'         => zone_id,
            'snapshotid'     => snapshot_id,
            'projectid'      => project_id
          }

          data = service.create_volume(options)
          merge_attributes(data['createvolumeresponse'])
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

        def snapshots
          requires :id
          service.snapshots.all('volumeid' => id)
        end

        def reload
          requires :identity

          return unless data = begin
                                 collection.get(identity)
                               rescue Excon::Errors::SocketError
                                 nil
                               end

          new_attributes = {
            'virtualmachineid' => nil,
            'vmname' => nil,
            'vmdisplayname' => nil
          }.merge(data.attributes)

          merge_attributes(new_attributes)
          self
        end

        def attach(instance_or_id, mountpoint=nil)
          requires :id
          instance_id = instance_or_id.is_a?(Server) ? instance_or_id.id : instance_or_id
          unless instance_id
            raise ArgumentError, "Missing required argument: instance_or_id"
          end

          options = {
            'id'               => id,
            'virtualmachineid' => instance_id,
          }
          options.merge!('deviceid' => mountpoint) if mountpoint

          data = service.attach_volume(options)

					service.jobs.new(data["attachvolumeresponse"])
        end

        def detach
          requires :id

          data = service.detach_volume('id' => id)

          service.jobs.new(data["detachvolumeresponse"])
        end

        def destroy
          requires :id
          service.delete_volume('id' => id)
          true
        end
      end # Volume
    end # Cloudstack
  end # Compute
end # Fog
