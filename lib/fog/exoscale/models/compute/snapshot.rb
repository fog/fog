module Fog
  module Compute
    class Exoscale
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
          raise Fog::Errors::Error.new('Creating a snapshot is not supported')
        end

        def ready?
          state == 'BackedUp'
        end

        def volume
          service.volumes.get(volume_id) if volume_id
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying a snapshot is not supported')
        end
      end # Snapshot
    end # Exoscale
  end # Compute
end # Fog
