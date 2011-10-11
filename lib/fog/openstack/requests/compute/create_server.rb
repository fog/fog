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

          if options['metadata']
            data['server']['metadata'] = options['metadata']
          end
          if options['accessIPv4']
            data['server']['accessIPv4'] = options['accessIPv4']
          end
          if options['accessIPv6']
            data['server']['accessIPv6'] = options['accessIPv6']
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
          if options['availability_zone']
            data['server']['availability_zone'] = options['availability_zone']
          end
          request(
            :body     => MultiJson.encode(data),
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
            'addresses' => {},
            'flavor'  => {"id"=>"1", "links"=>[{"href"=>"http://nova1:8774/admin/flavors/1", "rel"=>"bookmark"}]},
            'id'        => Fog::Mock.random_numbers(6).to_s,
            'image'     => {"id"=>"3", "links"=>[{"href"=>"http://nova1:8774/admin/images/3", "rel"=>"bookmark"}]},
            'links'     => [{"href"=>"http://nova1:8774/v1.1/admin/servers/5", "rel"=>"self"}, {"href"=>"http://nova1:8774/admin/servers/5", "rel"=>"bookmark"}],
            'hostId'    => "123456789ABCDEF01234567890ABCDEF",
            'metadata'  => options['metadata'] || {},
            'name'      => options['name'] || "server_#{rand(999)}",
            'accessIPv4'  => options['accessIPv4'] || "",
            'accessIPv6'  => options['accessIPv6'] || "",
            'progress'  => 0,
            'status'    => 'BUILD'
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
