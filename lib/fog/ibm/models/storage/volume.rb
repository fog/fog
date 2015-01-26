require 'fog/core/model'

module Fog
  module Storage
    class IBM
      class Volume < Fog::Model
        STATES = {
          0  => 'New',
          1  => 'Creating',
          2  => 'Deleting',
          3  => 'Deleted',
          4  => 'Detached',
          5  => 'Attached',
          6  => 'Failed',
          7  => 'Deletion pending',
          8  => 'Being cloned',
          9  => 'Cloning',
          10 => 'Attaching',
          11 => 'Detaching',
          12 => 'Copying',
          13 => 'Importing',
          14 => 'Transfer retrying',
        }

        identity :id

        attribute :instance_id,   :aliases => "instanceId"
        attribute :io_price,      :aliases => "ioPrice"
        attribute :name
        attribute :state
        attribute :size
        attribute :offering_id,   :aliases => "offeringId"
        attribute :owner
        attribute :created_at,    :aliases => "createdTime"
        attribute :location_id,   :aliases => "location"
        attribute :product_codes, :aliases => "productCodes"
        attribute :format
        attribute :storage_area,     :aliases => 'storageArea'
        attribute :platform_version, :aliases => 'platformVersion'
        attribute :clone_status,     :aliases => 'cloneStatus'

        def attached?
          state == "Attached"
        end

        def attach(instance_id)
          requires :id
          service.attach_volume(instance_id, id).body['success']
        end

        def detach(instance_id)
          requires :id
          service.detach_volume(instance_id, id).body['success']
        end

        def created_at
          Time.at(attributes[:created_at].to_f / 1000)
        end

        def destroy
          requires :id
          service.delete_volume(id)
          true
        end

        def instance
          return nil if instance_id.nil? || instance_id == "0" || instance_id == ""
          Fog::Compute[:ibm].servers.get(instance_id)
        end

        def location
          requires :location_id
          Fog::Compute[:ibm].locations.get(location_id)
        end

        # Are we ready to be attached to an instance?
        def ready?
          # TODO: Not sure if this is the only state we should be matching.
          state == "Detached"
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :offering_id, :format, :location_id, :size
          data = service.create_volume(name, offering_id, format, location_id, size)
          merge_attributes(data.body)
          true
        end

        def state
          STATES[attributes[:state]]
        end
      end
    end
  end
end
