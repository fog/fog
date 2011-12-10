require 'fog/core/model'

module Fog
  module Storage
    class IBM
      class Volume < Fog::Model

        STATUS = [
          "New",              # => 0
          "Creating",         # => 1
          "Deleting",         # => 2
          "Deleted",          # => 3
          "Detached",         # => 4
          "Attached",         # => 5
          "Failed",           # => 6
          "Deletion pending", # => 7
          "Being cloned",     # => 8
          "Cloning",          # => 9
          "Attaching",        # => 10
          "Detaching",        # => 11
          "Copying",          # => 12
          "Importing",        # => 13
          "Transfer retrying" # => 14
        ]

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

        def attached?
          status == "Attached"
        end

        def attach(instance_id)
          requires :id
          connection.attach_volume(instance_id, id).body['success']
        end

        def detach(instance_id)
          requires :id
          connection.detach_volume(instance_id, id).body['success']
        end

        def created_at
          Time.at(attributes[:created_at].to_f / 1000)
        end

        def destroy
          requires :id
          connection.delete_volume(id)
          true
        end

        def instance
          return nil if instance_id == "0" || instance_id == ""
          Fog::Compute[:ibm].servers.get(instance_id)
        end

        def location
          requires :location_id
          Fog::Compute[:ibm].locations.get(location_id)
        end

        # Are we ready to be attached to an instance?
        def ready?
          # TODO: Not sure if this is the only status we should be matching.
          status == "Detached"
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :offering_id, :format, :location_id, :size
          data = connection.create_volume(name, offering_id, format, location_id, size)
          merge_attributes(data.body)
          true
        end

        def status
          STATUS[attributes[:state].to_i]
        end

      end
    end
  end
end
