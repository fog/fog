module Fog
  module Parsers
    module Compute
      module AWS

        class DescribeSecurityGroups < Fog::Parsers::Base

          def reset
            @group = {}
            @ip_permission = { 'groups' => [], 'ipRanges' => []}
            @ip_permission_egress = { 'groups' => [], 'ipRanges' => []}
            @ip_range = {}
            @security_group = { 'ipPermissions' => [], 'ipPermissionsEgress' => [] }
            @response = { 'securityGroupInfo' => [] }
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'groups'
              @in_groups = true
            when 'ipPermissions'
              @in_ip_permissions = true
            when 'ipPermissionsEgress'
              @in_ip_permissions_egress = true
            when 'ipRanges'
              @in_ip_ranges = true
            end
          end

          def end_element(name)
            case name
            when 'cidrIp'
              @ip_range[name] = value
            when 'fromPort', 'toPort'
              if @in_ip_permissions_egress
                @ip_permission_egress[name] = value.to_i              
              else
                @ip_permission[name] = value.to_i
              end
            when 'groups'
              @in_groups = false
            when 'groupDescription', 'ownerId', 'vpcId'
              @security_group[name] = value
            when 'groupId','groupName'
              if @in_groups
                @group[name] = value
              else
                @security_group[name] = value
              end
            when 'ipPermissions'
              @in_ip_permissions = false
            when 'ipPermissionsEgress'
              @in_ip_permissions_egress = false
            when 'ipProtocol'
              if @in_ip_permissions_egress
                @ip_permission_egress[name] = value
              else
                @ip_permission[name] = value
              end
            when 'ipRanges'
              @in_ip_ranges = false
            when 'item'
              if @in_groups
                if @in_ip_permissions_egress
                  @ip_permission_egress['group'] << @group
                else
                  @ip_permission['groups'] << @group
                end
                @group = {}
              elsif @in_ip_ranges
                if @in_ip_permissions_egress
                  @ip_permission_egress['ipRanges'] << @ip_range
                else
                  @ip_permission['ipRanges'] << @ip_range
                end
                @ip_range = {}
              elsif @in_ip_permissions
                @security_group['ipPermissions'] << @ip_permission
                @ip_permission = { 'groups' => [], 'ipRanges' => []}
              elsif @in_ip_permissions_egress
                @security_group['ipPermissionsEgress'] << @ip_permission_egress
                @ip_permission_egress = { 'groups' => [], 'ipRanges' => []}
              else
                @response['securityGroupInfo'] << @security_group
                @security_group = { 'ipPermissions' => [], 'ipPermissionsEgress' => [] }
              end
            when 'requestId'
              @response[name] = value
            when 'userId'
              @group[name] = value
            end
          end

        end

      end
    end
  end
end
