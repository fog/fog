module Fog
  module Compute
    class Cloudstack
      class Snapshot < Fog::Model
        identity  :id,                         :aliases => 'id'

        attribute :name,                       :aliases => 'name'
        attribute :volume_type,                :aliases => 'volumetype'
        attribute :volume_name,                :aliases => 'volumename'
        attribute :volume_id,                  :aliases => 'volumeid'
        attribute :created,                    :aliases => 'created'
        attribute :state,                      :aliases => 'state'
        attribute :account,                    :aliases => 'account'
        attribute :domain_id,                  :aliases => 'domainid'
        attribute :domain,                     :aliases => 'domain'
        attribute :snapshot_type,              :aliases => 'snapshot_type'
        attribute :interval_type,              :aliases => 'interval_type'

        def save
          requires :volume_id

          options = {
            'volumeid'      => volume_id,
            'domainid'      => domain_id
          }
          data = service.create_snapshot(options)
          merge_attributes(data['createsnapshotresponse'])
        end

        def ready?
          state == 'BackedUp'
        end

        def volume
          service.volumes.get(volume_id) if volume_id
        end

        def destroy
          requires :id
          service.delete_snapshot('id' => id)
          true
        end
      end # Snapshot
    end # Cloudstack
  end # Compute
end # Fog
