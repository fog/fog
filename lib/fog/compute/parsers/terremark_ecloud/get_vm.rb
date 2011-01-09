module Fog
  module Parsers
    module TerremarkEcloud
      module Compute

        class GetVm < Fog::Parsers::Base

          def reset
            @response = {
              'network_connections' => [],
              'disks' => []
            }

            @network_connection    = {}
            @virtual_hardware_item = {}
          end

          def start_element(name, attrs = [])
            case name
            when 'VApp'
              @response['name'] = attr_value('name', attrs)
              @response['uri']  = attr_value('href', attrs)
              @response['status'] = case attr_value('status', attrs)
                                    when '0' then 'creating'
                                    when '1' then 'deploying'
                                    when '2' then 'powered_off'
                                    when '4' then 'powered_on'
                                    end
              @response['storage_size'] = attr_value('size', attrs).to_i
            when 'Link'
              href = attr_value('href', attrs)

              case attr_value('type', attrs)
              when 'application/vnd.vmware.vcloud.vdc+xml'
                @response['vdc_uri'] = href
              when 'application/vnd.tmrk.ecloud.vApp+xml'
                @response['extension_uri'] = href
              end
            when 'NetworkConnectionSection'
              @in_network_connection_section = true
            when 'NetworkConnection'
              if @in_network_connection_section
                @in_network_connection = true
                @network_connection = { 'name' => attr_value('Network', attrs) }
              end
            when 'VirtualHardwareSection'
              @in_virtual_hardware_section = true
            when 'Item'
              if @in_virtual_hardware_section
                @in_virtual_hardware_item = true
                @virtual_hardware_item = {}
              end
            end

            super
          end

          def end_element(name)
            case name
            when 'NetworkConnectionSection'
              @in_network_connection_section = false
            when 'NetworkConnection'
              if @in_network_connection_section
                @in_network_connection = false
                @response['network_connections'].push(@network_connection)
              end
            when 'IpAddress'
              @in_network_connection && @network_connection['ip_address'] = @value
            when 'Item'
              if @in_virtual_hardware_item
                @in_virtual_hardware_item = false

                case @virtual_hardware_item['type']
                when 3
                  @response['cpus'] = @virtual_hardware_item['count']
                when 4
                  @response['memory'] = @virtual_hardware_item['count']
                when 17
                  @response['disks'].push({
                                            'id'   => @virtual_hardware_item['id'],
                                            'size' => @virtual_hardware_item['count']
                                          })
                end
              end
            when 'AddressOnParent'
              if @in_virtual_hardware_item
                @virtual_hardware_item['id'] = @value.to_i
              end
            when 'ResourceType'
              if @in_virtual_hardware_item
                @virtual_hardware_item['type'] = @value.to_i
              end
            when 'VirtualQuantity'
              if @in_virtual_hardware_item
                @virtual_hardware_item['count'] = @value.to_i
              end
            end

          end

        end
      end
    end
  end
end
