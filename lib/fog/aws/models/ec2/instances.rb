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
          data = connection.describe_instances(instance_id).body
          instances = Fog::AWS::EC2::Instances.new({
            :connection   => connection,
            :instance_id  => instance_id
          }.merge!(attributes))
          data['reservationSet'].each do |reservation|
            reservation['instancesSet'].each do |instance|
              instances << Fog::AWS::EC2::Instance.new({
                :collection => instances,
                :connection => connection
              }.merge!(instance))
            end
          end
          instances
        end

        def get(instance_id)
          if instance_id
            all(instance_id).first
          end
        rescue Fog::Errors::BadRequest
          nil
        end

      end

    end
  end
end
