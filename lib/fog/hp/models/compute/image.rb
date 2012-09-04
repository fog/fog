require 'fog/core/model'

module Fog
  module Compute
    class HP

      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :created_at,  :aliases => 'created'
        attribute :updated_at,  :aliases => 'updated'
        attribute :progress
        attribute :status
        attribute :minDisk,     :aliases => 'min_disk'
        attribute :minRam,      :aliases => 'min_ram'
        attribute :server,   :aliases => 'server'
        attribute :metadata       
        attribute :links

        def destroy
          requires :id

          connection.delete_image(id)
          true
        end

        def ready?
          status == 'ACTIVE'
        end

      end

    end
  end
end
