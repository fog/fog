module Fog
  module AWS
    class EC2

      def instances
        Fog::AWS::EC2::Instances.new(:connection => self)
      end

      class Instances < Fog::Collection

        attribute :instance_id

        model Fog::AWS::EC2::Instance

        def initialize(attributes)
          @instance_id ||= []
          super
        end

        def all(instance_id = @instance_id)
          @instance_id = instance_id
          if @loaded
            clear
          end
          @loaded = true
          data = connection.describe_instances(instance_id).body
          data['reservationSet'].each do |reservation|
            reservation['instancesSet'].each do |instance|
              self << new(instance)
            end
          end
          self
        end

        def get(instance_id)
          if instance_id
            all(instance_id).first
          end
        rescue Excon::Errors::BadRequest
          nil
        end

      end

    end
  end
end
