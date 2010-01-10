module Fog
  module AWS
    class EC2

      def images
        Fog::AWS::EC2::Images.new(:connection => self)
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
          if @loaded
            clear
          end
          @loaded = true
          data = connection.describe_images('ImageId' => image_id).body
          data['imagesSet'].each do |image|
            self << new(image)
          end
          self
        end

        def get(image_id)
          if image_id
            all(image_id).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end
      end

    end
  end
end
