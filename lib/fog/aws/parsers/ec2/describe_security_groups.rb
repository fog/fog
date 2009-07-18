module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeSecurityGroups < Fog::Parsers::Base

          def reset
            @group = {}
            @ip_permission = { :groups => [], :ip_ranges => []}
            @ip_range = {}
            @security_group = { :ip_permissions => [] }
            @response = { :security_group_info => [] }
          end

          def start_element(name, attrs = [])
            if name == 'groups'
              @in_groups = true
            elsif name == 'ipPermissions'
              @in_ip_permissions = true
            elsif name == 'ipRanges'
              @in_ip_ranges = true
            end
            @value = ''
          end

          def end_element(name)
            case name
            when 'cidrIp'
              @ip_range[:cidrIp] = @value
            when 'fromPort'
              @ip_permission[:from_port] = @value.to_i
            when 'groups'
              @in_groups = false
            when 'groupDescription'
              @security_group[:group_description] = @value
            when 'groupName'
              if @in_groups
                @group[:group_name] = @value
              else
                @group[:group_name] = @value
              end
            when 'ipPermissions'
              @in_ip_permissions = false
            when 'ipProtocol'
              @ip_permission[:ip_protocol] = @value
            when 'ipRanges'
              @in_ip_ranges = false
            when 'item'
              if @in_groups
                @ip_permission[:groups] << @group
                @group = {}
              elsif @in_ip_permissions
                @security_group[:ip_permissions] << @ip_permission
                @ip_permission = { :groups => [], :ip_ranges => []}
              elsif @in_ip_ranges
                @ip_permission[:ip_ranges] << @ip_range
                @ip_range = {}
              else
                @response[:security_group_info] << @security_group
                @security_group = { :ip_permissions => [] }
              end
            when 'ownerId'
              @security_group[:owner_id] = @value
            when 'requestId'
              @response[:request_id] = @value
            when 'toPort'
              @ip_permission[:to_port] = @value.to_i
            when 'userId'
              @group[:user_id] = @value
            end
          end

        end

      end
    end
  end
end
