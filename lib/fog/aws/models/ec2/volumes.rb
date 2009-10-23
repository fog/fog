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
        attribute :instance

        def initialize(attributes)
          @volume_id ||= []
          super
        end

        def all(volume_id = [])
          data = connection.describe_volumes(volume_id).body
          volumes = Fog::AWS::EC2::Volumes.new({
            :connection => connection,
            :volume_id  => volume_id
          }.merge!(attributes))
          data['volumeSet'].each do |volume|
            volumes << Fog::AWS::EC2::Volume.new({
              :connection => connection,
              :volumes    => self
            }.merge!(volume))
          end
          if instance
            volumes = volumes.select {|volume| volume.instance_id == instance.id}
          end
          volumes
        end

        def create(attributes = {})
          volume = new(attributes)
          volume.save
          volume
        end

        def get(volume_id)
          if volume_id
            all(volume_id).first
          end
        rescue Fog::Errors::BadRequest
          nil
        end

        def new(attributes = {})
          volume = Fog::AWS::EC2::Volume.new(
            attributes.merge!(
              :connection   => connection,
              :instance     => instance,
              :volumes      => self
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
