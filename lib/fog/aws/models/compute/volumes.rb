require 'fog/core/collection'
require 'fog/aws/models/compute/volume'

module Fog
  module AWS
    class Compute

      class Volumes < Fog::Collection

        attribute :volume_id
        attribute :server

        model Fog::AWS::Compute::Volume

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
            self.class.new(:connection => connection).all(volume_id).first
          end
        rescue Fog::Errors::NotFound
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
