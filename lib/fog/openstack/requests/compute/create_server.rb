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
                             'availability_zone', 'user_data', 'key_name', 'adminPass']
          vanilla_options.select{|o| options[o]}.each do |key|
            data['server'][key] = options[key]
          end

          if options['security_groups']
            # security names requires a hash with a name prefix
            data['server']['security_groups'] = [options['security_groups']].flatten.map do |sg|
              { :name => sg.is_a?(Fog::Compute::OpenStack::SecurityGroup) ? sg.name : sg }
            end
          end

          if options['personality']
            data['server']['personality'] = []
            for file in options['personality']
              data['server']['personality'] << {
                'contents'  => Base64.encode64(file['contents']),
                'path'      => file['path']
              }
            end
          end

          if options['os:scheduler_hints']
            data['os:scheduler_hints'] = options['os:scheduler_hints']
          end

          request(
            :body     => Fog::JSON.encode(data),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => 'servers.json'
          )
        end

      end

      class Mock

        def create_server(name, image_ref, flavor_ref, options = {})
          response = Excon::Response.new
          response.status = 202

          data = {
            'addresses'  => {},
            'flavor'     => {"id" => flavor_ref, "links"=>[{"href"=>"http://nova1:8774/admin/flavors/1", "rel"=>"bookmark"}]},
            'id'         => Fog::Mock.random_numbers(6).to_s,
            'image'      => {"id" => image_ref, "links"=>[{"href"=>"http://nova1:8774/admin/images/#{image_ref}", "rel"=>"bookmark"}]},
            'links'      => [{"href"=>"http://nova1:8774/v1.1/admin/servers/5", "rel"=>"self"}, {"href"=>"http://nova1:8774/admin/servers/5", "rel"=>"bookmark"}],
            'hostId'     => "123456789ABCDEF01234567890ABCDEF",
            'metadata'   => options['metadata'] || {},
            'name'       => name || "server_#{rand(999)}",
            'accessIPv4' => options['accessIPv4'] || "",
            'accessIPv6' => options['accessIPv6'] || "",
            'progress'   => 0,
            'status'     => 'BUILD',
            'created'    => '2012-09-27T00:04:18Z',
            'updated'    => '2012-09-27T00:04:27Z',
          }

          self.data[:last_modified][:servers][data['id']] = Time.now
          self.data[:servers][data['id']] = data
          response.body = { 'server' => data.merge({'adminPass' => 'password'}) }
          response
        end

      end
    end
  end
end
