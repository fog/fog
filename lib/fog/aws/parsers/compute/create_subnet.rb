module Fog
  module Parsers
    module Compute
      module AWS

        class CreateSubnet < Fog::Parsers::Base

          def reset
            @subnet = { 'tagSet' => {} }
            @response = { 'subnetSet' => [] }
            @tag = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'tagSet'
              @in_tag_set = true
            end
          end

          def end_element(name)
            if @in_tag_set
              case name
                when 'item'
                  @subnet['tagSet'][@tag['key']] = @tag['value']
                  @tag = {}
                when 'key', 'value'
                  @tag[name] = value
                when 'tagSet'
                  @in_tag_set = false
              end
            else
              case name
              when 'subnetId', 'state', 'vpcId', 'cidrBlock', 'availableIpAddressCount', 'availabilityZone'
                @subnet[name] = value
              when 'subnet'
                @response['subnetSet'] << @subnet
                @subnet = { 'tagSet' => {} }
              when 'requestId'
                @response[name] = value
              end
            end
          end
        end
      end
    end
  end
end


