module Fog
  module AWS
    class EC2

      def instances
        Fog::AWS::EC2::Instances.new(:connection => self)
      end

      class Instances < Fog::Collection

        def all(instance_id = [])
          data = connection.describe_instances(instance_id)
          instances = Fog::AWS::EC2::Instances.new(:connection => connection)
          data['instancesSet'].each do |instance|
            instances << Fog::AWS::EC2::Instances.new({
              :connection => connection,
              :instances  => self
            }.merge!(instance))
          end
          instances
        end

        def create(attributes = {})
          instance = new(attributes)
          instance.save
          instance
        end

        def new(attributes = {})
          Fog::AWS::EC2::Instance.new(
            attributes.merge!(
              :connection => connection,
              :instances  => self
            )
          )
        end

      end

    end
  end
end
