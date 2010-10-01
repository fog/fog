require 'fog/collection'
require 'fog/aws/models/compute/security_group'

module Fog
  module AWS
    class Compute

      class SecurityGroups < Fog::Collection

        attribute :group_name

        model Fog::AWS::Compute::SecurityGroup

        def initialize(attributes)
          @group_name ||= []
          super
        end

        def all(group_name = @group_name)
          @group_name = group_name
          data = connection.describe_security_groups(group_name).body
          load(data['securityGroupInfo'])
        end

        def get(group_name)
          if group_name
            self.class.new(:connection => connection).all(group_name).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
