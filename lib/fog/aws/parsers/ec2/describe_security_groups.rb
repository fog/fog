module Fog
  module Parsers
    module AWS
      module EC2

        class DescribeSecurityGroups < Fog::Parsers::Base

          def reset
            @group = {}
            @ip_permission = { :groups => [], :ip_ranges => []}
            @ip_range = {}
            @in_ip_permissions = false
            @item = { :ip_permissions => [] }
            @response = { :security_group_info => [] }
          end

          def start_element(name, attrs = [])
            if name == 'ipRanges'
              @in_ip_ranges = true
            elsif name == 'ipPermissions'
              @in_ip_permissions = true
            elsif name == 'groups'
              @in_groups = true
            end
            @value = ''
          end

          def end_element(name)
            if !@in_ip_permissions
              case name
              when 'groupName'
                @item[:group_name] = @value
              when 'groupDescription'
                @item[:group_description] = @value
              when 'item'
                @response[:security_group_info] << @item
                @item = { :ip_permissions => [] }
              when 'ownerId'
                @item[:owner_id] = @value
              end
            elsif @in_groups
              case name
              when 'groupName'
                @group[:group_name] = @value
              when 'groups'
                @in_groups = false
              when 'item'
                unless @group == {}
                  @ip_permission[:groups] << @group
                end
                @group = {}
              when 'userId'
                @group[:user_id] = @value
              end
            elsif @in_ip_ranges
              case name
              when 'cidrIp'
                @ip_range[:cidr_ip] = @value
              when 'ipRanges'
                @in_ip_ranges = false
              when 'item'
                unless @ip_range == {}
                  @ip_permission[:ip_ranges] << @ip_range
                end
                @ip_range = {}
              end
            elsif @in_ip_permissions
              case name
              when 'fromPort'
                @item[:from_port] = @value
              when 'item'
                @item[:ip_permissions] << @ip_permission
                @ip_permission = { :groups => [], :ip_ranges => []}
              when 'ipProtocol'
                @ip_permission[:ip_protocol] = @value
              when 'ipPermissions'
                @in_ip_permissions = false
              when 'toPort'
                @item[:to_port] = @value
              end
            end
          end

        end

      end
    end
  end
end
