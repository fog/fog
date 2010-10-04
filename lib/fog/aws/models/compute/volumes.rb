require 'fog/core/collection'
require 'fog/aws/models/compute/volume'

module Fog
  module AWS
    class Compute

      class Volumes < Fog::Collection

        attribute :filters
        attribute :server

        model Fog::AWS::Compute::Volume

        def initialize(attributes)
          @filters ||= {}
          super
        end

        def all(filters = @filters)
          @filters = filters
          data = connection.describe_volumes(@filters).body
          load(data['volumeSet'])
          if server
            self.replace(self.select {|volume| volume.server_id == server.id})
          end
          self
        end

        def get(volume_id)
          if volume_id
            self.class.new(:connection => connection).all('volume-id' => volume_id).first
          end
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
