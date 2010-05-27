require 'fog/collection'
require 'fog/aws/models/ec2/image'

module Fog
  module AWS
    module EC2

      class Mock
        def images
          Fog::AWS::EC2::Images.new(:connection => self)
        end
      end

      class Real
        def images
          Fog::AWS::EC2::Images.new(:connection => self)
        end
      end

      class Images < Fog::Collection

        attribute :image_id

        model Fog::AWS::EC2::Image

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
