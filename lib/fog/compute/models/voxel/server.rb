require 'fog/compute/models/server'

module Fog
  module Compute
    class Voxel

      class Server < Fog::Compute::Server

        identity :id

        attribute :name
        attribute :processing_cores
        attribute :image_id
        attribute :facility
        attribute :disk_size
        attribute :ip_assignments, :aliases => 'ipassignments'

        def initialize(attributes={})
          self.image_id ||= '55' # Ubuntu 10.04 LTS 64bit
          super
        end

        def destroy
          requires :id
          connection.voxcloud_delete(id)
          true
        end

        def image
          requires :image_id
          connection.images.get(image_id)
        end

        def ready?
          self.state == 'SUCCEEDED'
        end

        def private_ip_address
          ip_assignments.select {|ip_assignment| ip_assignment['type'] == 'internal'}.first
        end

        def public_ip_address
          ip_assignments.select {|ip_assignment| ip_assignment['type'] == 'external'}.first
        end

        def reboot
          requires :id
          connection.devices_power(id, :reboot)
          true
        end

        def state
          @state ||= connection.voxcloud_status(id).body['devices'].first['status']
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :image_id, :processing_cores, :facility, :disk_size

          data = connection.voxcloud_create({
            :disk_size => disk_size,
            :facility => facility,
            :hostname => name,
            :image_id => image_id,
            :processing_cores => processing_cores
          }).body

          merge_attributes(data['device'])

          true
        end

      end

    end

  end
end
