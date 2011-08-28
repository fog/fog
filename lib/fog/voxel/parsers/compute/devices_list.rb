module Fog
  module Parsers
    module Compute
      module Voxel

        class DevicesList < Fog::Parsers::Base

          def reset
            @device          = {}
            @response        = { 'devices' => [] }
            @in_storage      = false
          end

          def start_element(name, attrs = [])
            super

            case name
            when 'accessmethod'
              @access_method = { 'type' => attr_value('type', attrs) }
            when 'accessmethods'
              @device['access_methods'] = []
            when 'device'
              @device = {
                'id'      => attr_value('id', attrs),
                'label'   => attr_value('label', attrs),
                'status'  => attr_value('status', attrs)
              }
            when 'err'
              @response['err'] = {
                'code'  => attr_value('code', attrs),
                'msg'   => attr_value('msg', attrs)
              }
            when 'cage', 'facility', 'rack', 'row', 'zone'
              @device['location'][name] = { 'id' => attr_value('id', attrs) }
              if code = attr_value('code', attrs)
                @device['location'][name]['code'] = code
              end
            when 'drive'
              @drive = { 'position' => attr_value('position', attrs) }
            when 'ipassignment'
              type = attr_value('type', attrs)
              @device['ipassignments'] = []
              @device['ipassignments'] << {
                'id'          => attr_value('id', attrs),
                'type'        => attr_value('type', attrs),
                'description' => attr_value('description', attrs),
              }
            when 'ipassignments'
              @device['ipassignments'] = {}
            when 'location'
              @device['location'] = {}
            when 'memory'
              @device['memory'] = { 'size' =>  attr_value('size', attrs).to_i }
            when 'model', 'type'
              @device[name] = { 'id'    => attr_value('id', attrs) }
            when 'operating_system'
              @device['operating_system'] = {}
            when 'power_consumption'
              @device[name] = attr_value('unit', attrs)
            when 'processor'
              @device['processor'] = {}
            when 'rsp'
              @response['stat'] = attr_value('stat', attrs)
            when 'storage'
              @device['drives'] = []
            end
          end

          def end_element(name)
            case name
            when 'access_method'
              @device['access_methods'] << @access_method
            when 'architecture'
              @device['operating_system'][name] = value.to_i
            when 'cage', 'facility', 'rack', 'row', 'zone'
              @device['location'][name]['value'] = value
            when 'cores'
              @device['processor'][name] = value.to_i
            when 'description'
              @device[name] = value
            when 'device'
              @response['devices'] << @device
              @device = {}
            when 'drive'
              @device['drives'] << @drive
              @drive = {}
            when 'cores'
              @device['processing_cores'] = value.to_i
            when 'ipassignment'
              @device['ipassignments'].last['value'] = value
            when 'model', 'type'
              @device[name]['value'] = value
            when 'name'
              @device['operating_system'][name] = value
            when 'position'
              @device['location'][name] = value
            when 'power_consumption'
              @device[name] = [value, @device[name]].join(' ')
            when 'size'
              @drive[name] = value.to_i
            when 'host', 'password', 'protocol', 'username'
              @access_method[name] = value
            end
          end

        end

      end
    end
  end
end
