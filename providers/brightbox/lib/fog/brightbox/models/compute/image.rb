require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class Image < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :username
        attribute :status
        attribute :description

        attribute :source
        attribute :source_type
        attribute :arch
        attribute :virtual_size
        attribute :disk_size
        attribute :licence_name

        # Boolean flags
        attribute :public
        attribute :official
        attribute :compatibility_mode

        # Times
        attribute :created_at, :type => :time

        # Links - to be replaced
        attribute :ancestor_id, :aliases => "ancestor", :squash => "id"
        attribute :owner_id, :aliases => "owner", :squash => "id"

        def ready?
          status == "available"
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :source, :arch
          options = {
            :source => source,
            :arch => arch,
            :name => name,
            :username => username,
            :description => description
          }.delete_if { |k, v| v.nil? || v == "" }
          data = service.create_image(options)
          merge_attributes(data)
          true
        end

        def destroy
          requires :identity
          service.destroy_image(identity)
          true
        end
      end
    end
  end
end
