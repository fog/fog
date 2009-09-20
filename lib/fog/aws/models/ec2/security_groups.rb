module Fog
  module AWS
    class EC2

      def security_groups
        Fog::AWS::EC2::SecurityGroups.new(:connection => self)
      end

      class SecurityGroups < Fog::Collection

        def all(group_name = [])
          data = connection.describe_security_groups(group_name)
          security_groups = Fog::AWS::EC2::SecurityGroups.new(:connection => connection)
          data['securityGroupInfo'].each do |security_group|
            security_groups << Fog::AWS::EC2::SecurityGroup.new({
              :connection       => connection,
              :security_groups  => self
            }.merge!(security_group))
          end
          security_groups
        end

        def create(attributes = {})
          security_group = new(attributes)
          security_group.save
          security_group
        end

        def new(attributes = {})
          Fog::AWS::EC2::SecurityGroup.new(
            attributes.merge!(
              :connection => connection,
              :security_groups  => self
            )
          )
        end

      end

    end
  end
end
