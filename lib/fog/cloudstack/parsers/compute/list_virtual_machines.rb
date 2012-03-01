module Fog
  module Parsers
    module Compute
      module Cloudstack

        class ListVirtualMachines < Fog::Parsers::Base

          def reset
            @context = []
            @contexts = ['nic', 'securitygroup']
            @instance = {}
            @response = {'virtualMachines' => []}
          end

          def start_element(name, attrs = [])
            super
            if @contexts.include?(name)
              @context.push(name)
            end
          end

          def end_element(name)
            case name
              when 'templateid'
                @instance['imageId'] = value
              when 'serviceofferingid'
                @instance['instanceType'] = value
              when 'ipaddress'
                @instance['ipAddress'] = value
              when 'state'
                @instance['instanceState'] = value
              when 'name'
                case @context.last
                  when 'nic'
                  when 'securitygroup'
                  else
                    @instance['name'] = value
                end
              when 'displayname'
                @instance['displayName'] = value
              when 'id'
                case @context.last
                  when 'nic'
                  when 'securitygroup'
                  else
                    @instance['instanceId'] = value
                end
              when *@contexts
                @context.pop
              when 'virtualmachine'
                @response['virtualMachines'] << @instance
                @instance = {}
              when 'group'
                @instance['groupName'] = value
            end
          end
        end
      end
    end
  end
end
