module Fog
  module AWS
    class EC2

      def volumes
        Fog::AWS::EC2::Volumes.new(:connection => self)
      end

      class Volumes < Fog::Collection

        def all(volume_id = [])
          data = connection.describe_volumes(volume_id)
          volumes = Fog::AWS::EC2::Volumes.new(:connection => connection)
          data['volumeSet'].each do |volume|
            volumes << Fog::AWS::EC2::Volume.new({
              :connection => connection,
              :volumes    => self
            }.merge!(volume))
          end
          volumes
        end

        def create(attributes = {})
          volume = new(attributes)
          volume.save
          volume
        end

        def new(attributes = {})
          Fog::AWS::EC2::Volume.new(attributes.merge!(:connection => connection))
        end

      end

    end
  end
end
