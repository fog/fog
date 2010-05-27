require 'fog/collection'
require 'fog/aws/models/ec2/security_group'

module Fog
  module AWS
    module EC2

      class Mock
        def security_groups
          Fog::AWS::EC2::SecurityGroups.new(:connection => self)
        end
      end

      class Real
        def security_groups
          Fog::AWS::EC2::SecurityGroups.new(:connection => self)
        end
      end

      class SecurityGroups < Fog::Collection

        attribute :group_name

        model Fog::AWS::EC2::SecurityGroup

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
            all(group_name).first
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
