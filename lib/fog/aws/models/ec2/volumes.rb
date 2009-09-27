module Fog
  module AWS
    class EC2

      def volumes
        Fog::AWS::EC2::Volumes.new(:connection => self)
      end

      class Volumes < Fog::Collection

        attribute :volume_id

        def all(volume_id = [])
          data = connection.describe_volumes(volume_id).body
          volumes = Fog::AWS::EC2::Volumes.new({
            :connection => connection
          }.merge!(attributes))
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

        def get(volume_id)
          all(volume_id).first
        rescue Fog::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          Fog::AWS::EC2::Volume.new(
            attributes.merge!(
              :connection => connection,
              :volumes    => self
            )
          )
        end

        def reload
          all(volume_id)
        end

      end

    end
  end
end
