require 'fog/core/model'

module Fog
  module Image
    class OpenStack

      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :size
        attribute :disk_format
        attribute :container_format
        attribute :id
        attribute :checksum

        #detailed
        attribute :min_disk
        attribute :created_at
        attribute :deleted_at
        attribute :updated_at
        attribute :deleted
        attribute :protected
        attribute :is_public
        attribute :status
        attribute :min_ram
        attribute :owner
        attribute :properties
        attribute :location
        attribute :copy_from


        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save
          requires :name
          identity ? update : create
        end

        def create
          requires :name
          merge_attributes(connection.create_image(self.attributes).body['image'])
            self
        end

        def update
          requires :name
          merge_attributes(connection.update_image(self.attributes).body['image'])
          self
        end

        def destroy
          requires :id
          connection.delete_image(self.id)
          true
        end

        def add_member(member_id)
          requires :id
          connection.add_member_to_image(self.id, member_id)
        end

        def remove_member(member_id)
          requires :id
          connection.remove_member_from_image(self.id, member_id)
        end

        def members
          requires :id
          connection.get_image_members(self.id).body['members']
        end

        def metadata
          requires :id
          connection.get_image(self.id).headers
        end

      end
    end
  end
end
