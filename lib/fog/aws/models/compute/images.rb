require 'fog/collection'
require 'fog/aws/models/compute/image'

module Fog
  module AWS
    class Compute

      class Images < Fog::Collection

        attribute :image_id

        model Fog::AWS::Compute::Image

        def initialize(attributes)
          @image_id ||= []
          super
        end

        def all(image_id = @image_id)
          @image_id = image_id
          data = connection.describe_images('ImageId' => image_id).body
          load(data['imagesSet'])
        end

        def get(image_id)
          if image_id
            all(image_id).first
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end

    end
  end
end
