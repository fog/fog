require 'fog/core/collection'
require 'fog/compute/models/aws/security_group'

module Fog
  module AWS
    class Compute

      class SecurityGroups < Fog::Collection

        attribute :filters

        model Fog::AWS::Compute::SecurityGroup

        # Creates a new security group
        #
        # AWS.security_groups.new
        #
        # ==== Returns
        #
        # Returns the details of the new image
        #
        #>> AWS.security_groups.new
        #  <Fog::AWS::Compute::SecurityGroup
        #    name=nil,
        #    description=nil,
        #    ip_permissions=nil,
        #    owner_id=nil
        #  >
        #
        
        def initialize(attributes)
          self.filters ||= {}
          super
        end
        
        # Returns an array of all security groups that have been created
        #
        # AWS.security_groups.all
        #
        # ==== Returns
        #
        # Returns an array of all security groups
        #
        #>> AWS.security_groups.all
        #  <Fog::AWS::Compute::SecurityGroups
        #    filters={}
        #    [
        #      <Fog::AWS::Compute::SecurityGroup
        #        name="default",
        #        description="default group",
        #        ip_permissions=[{"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>-1, "toPort"=>-1, "ipRanges"=>[], "ipProtocol"=>"icmp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"tcp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"udp"}],
        #        owner_id="312571045469"
        #      >
        #    ]
        #  >
        #

        def all(filters = filters)
          unless filters.is_a?(Hash)
            Formatador.display_line("[yellow][WARN] all with #{filters.class} param is deprecated, use all('group-name' => []) instead[/] [light_black](#{caller.first})[/]")
            filters = {'group-name' => [*filters]}
          end
          self.filters = filters
          data = connection.describe_security_groups(filters).body
          load(data['securityGroupInfo'])
        end

        # Used to retreive a security group
        # group name is required to get the associated flavor information.
        #
        # You can run the following command to get the details:
        # AWS.security_groups.get("default")
        #
        # ==== Returns
        #
        #>> AWS.security_groups.get("default")
        #  <Fog::AWS::Compute::SecurityGroup
        #    name="default",
        #    description="default group",
        #    ip_permissions=[{"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>-1, "toPort"=>-1, "ipRanges"=>[], "ipProtocol"=>"icmp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"tcp"}, {"groups"=>[{"groupName"=>"default", "userId"=>"312571045469"}], "fromPort"=>0, "toPort"=>65535, "ipRanges"=>[], "ipProtocol"=>"udp"}],
        #    owner_id="312571045469"
        #  > 
        #
        
        def get(group_name)
          if group_name
            self.class.new(:connection => connection).all('group-name' => group_name).first
          end
        end

      end

    end
  end
end
