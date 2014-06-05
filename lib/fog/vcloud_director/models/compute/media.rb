require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Media < Model
        identity  :id

        attribute :href
        attribute :type
        attribute :name
        attribute :status, :type => :integer
        attribute :image_type, :aliases => :imageType
        attribute :size, :type => :integer
        attribute :description, :aliases => :Description

        # @return [Boolean]
        def destroy
          requires :id
          response = service.delete_media(id)
          service.process_task(response.body)
        end
      end
    end
  end
end
