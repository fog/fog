module Fog
  module AWS
    class EC2

      def volumes(attributes = {})
        Fog::AWS::EC2::Volumes.new({
          :connection => self
        }.merge!(attributes))
      end

      class Volumes < Fog::Collection

        attribute :volume_id
        attribute :server

        model Fog::AWS::EC2::Volume

        def initialize(attributes)
          @volume_id ||= []
          super
        end

        def all(volume_id = @volume_id)
          @volume_id = volume_id
          data = connection.describe_volumes(volume_id).body
          load(data['volumeSet'])
          if server
            self.replace(self.select {|volume| volume.server_id == server.id})
          end
          self
        end

        def get(volume_id)
          if volume_id
            all(volume_id).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          if server
            super({ :server => server }.merge!(attributes))
          else
            super
          end
        end

      end

    end
  end
end
