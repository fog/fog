module Fog
  module Compute
    class OpenStack
      class Real
        def create_server(name, image_ref, flavor_ref, options = {})
          data = {
            'server' => {
              'flavorRef'  => flavor_ref,
              'imageRef'   => image_ref,
              'name'       => name
            }
          }

          vanilla_options = ['metadata', 'accessIPv4', 'accessIPv6',
                             'availability_zone', 'user_data', 'key_name',
                             'adminPass', 'config_drive', 'min_count', 'max_count',
                             'return_reservation_id'
                            ]
          vanilla_options.select{|o| options[o]}.each do |key|
            data['server'][key] = options[key]
          end

          if options['security_groups']
            # security names requires a hash with a name prefix
            data['server']['security_groups'] =
              Array(options['security_groups']).map do |sg|
              name = if sg.is_a?(Fog::Compute::OpenStack::SecurityGroup) then
                       sg.name
                     else
                       sg
                     end
              { :name => name }
            end
          end

          if options['personality']
            data['server']['personality'] = []
            for file in options['personality']
              data['server']['personality'] << {
                'contents'  => Base64.encode64(file['contents'] || file[:contents]),
                'path'      => file['path'] || file[:path]
              }
            end
          end

          if options['nics']
            data['server']['networks'] =
            Array(options['nics']).map do |nic|
              neti = { 'uuid' => (nic['net_id'] || nic[:net_id]) }
              neti['fixed_ip'] = (nic['v4_fixed_ip'] || nic[:v4_fixed_ip]) unless (nic['v4_fixed_ip'] || nic[:v4_fixed_ip]).nil?
              neti['port'] = (nic['port_id'] || nic[:port_id]) unless (nic['port_id'] || nic[:port_id]).nil?
              neti
            end
          end

          if options['os:scheduler_hints']
            data['os:scheduler_hints'] = options['os:scheduler_hints']
          end

          if (block_device_mapping = options['block_device_mapping_v2'])
            data['server']['block_device_mapping_v2'] = [block_device_mapping].flatten.collect do |mapping|
              {
                'boot_index'            => mapping[:boot_index],
                'delete_on_termination' => mapping[:delete_on_termination],
                'destination_type'      => mapping[:destination_type],
                'device_name'           => mapping[:device_name],
                'source_type'           => mapping[:source_type],
                'uuid'                  => mapping[:uuid],
                'volume_size'           => mapping[:volume_size],
              }
            end
          elsif (block_device_mapping = options['block_device_mapping'])
            data['server']['block_device_mapping'] = [block_device_mapping].flatten.collect do |mapping|
              {
                'delete_on_termination' => mapping[:delete_on_termination],
                'device_name'           => mapping[:device_name],
                'volume_id'             => mapping[:volume_id],
                'volume_size'           => mapping[:volume_size],
              }
            end
          end

          path = block_device_mapping ? 'os-volumes_boot.json' : 'servers.json'

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => path
          )
        end
      end

      class Mock
        def create_server(name, image_ref, flavor_ref, options = {})
          response = Excon::Response.new
          response.status = 202

          server_id = Fog::Mock.random_numbers(6).to_s
          identity = Fog::Identity::OpenStack.new :openstack_auth_url => credentials[:openstack_auth_url]
          user = identity.users.find { |u|
            u.name == @openstack_username
          }

          user_id = if user then
                      user.id
                    else
                       response = identity.create_user(@openstack_username,
                         'password',
                         "#{@openstack_username}@example.com")
                       response.body["user"]["id"]
                    end

          mock_data = {
            'addresses'    => {"Private" => [{"addr" => Fog::Mock.random_ip }]},
            'flavor'       => {"id" => flavor_ref, "links"=>[{"href"=>"http://nova1:8774/admin/flavors/1", "rel"=>"bookmark"}]},
            'id'           => server_id,
            'image'        => {"id" => image_ref, "links"=>[{"href"=>"http://nova1:8774/admin/images/#{image_ref}", "rel"=>"bookmark"}]},
            'links'        => [{"href"=>"http://nova1:8774/v1.1/admin/servers/5", "rel"=>"self"}, {"href"=>"http://nova1:8774/admin/servers/5", "rel"=>"bookmark"}],
            'hostId'       => "123456789ABCDEF01234567890ABCDEF",
            'metadata'     => options['metadata'] || {},
            'name'         => name || "server_#{rand(999)}",
            'accessIPv4'   => options['accessIPv4'] || "",
            'accessIPv6'   => options['accessIPv6'] || "",
            'progress'     => 0,
            'status'       => 'BUILD',
            'created'      => '2012-09-27T00:04:18Z',
            'updated'      => '2012-09-27T00:04:27Z',
            'user_id'      => @openstack_username,
            'config_drive' => options['config_drive'] || '',
          }

          if nics = options['nics']
            nics.each do |nic|
              mock_data["addresses"].merge!(
                "Public" => [{ 'addr' => Fog::Mock.random_ip }]
              )
            end
          end

          response_data = {}
          if options['return_reservation_id'] == 'True' then
            response_data = { 'reservation_id' => "r-#{Fog::Mock.random_numbers(6).to_s}" }
          else
            response_data = {
              'adminPass'       => 'password',
              'id'              => server_id,
              'links'           => mock_data['links'],
            }
          end

          if block_devices = options["block_device_mapping_v2"]
            block_devices.each { |bd| compute.volumes.get(bd[:uuid]).attach(server_id, bd[:device_name]) }
          elsif block_device = options["block_device_mapping"]
            compute.volumes.get(block_device[:volume_id]).attach(server_id, block_device[:device_name])
          end

          self.data[:last_modified][:servers][server_id] = Time.now
          self.data[:servers][server_id] = mock_data
          if security_groups = options['security_groups'] then
            groups = Array(options['security_groups']).map do |sg|
              if sg.is_a?(Fog::Compute::OpenStack::SecurityGroup) then
                sg.name
              else
                sg
              end
            end

            self.data[:server_security_group_map][server_id] = groups
            response_data['security_groups'] = groups
          end

          self.data[:last_modified][:servers][server_id] = Time.now
          self.data[:servers][server_id] = mock_data
          if options['return_reservation_id'] == 'True' then
            response.body = response_data
          else
            response.body = { 'server' => response_data }
          end
          response
        end
      end
    end
  end
end
