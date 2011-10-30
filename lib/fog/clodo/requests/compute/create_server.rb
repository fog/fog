module Fog
  module Compute
    class Clodo
      class Real
        # Input:
        # vps_title - VDS title to display in VDS list
        # vps_type - VDS type (VirtualServer,ScaleServer)
        # vps_memory - memory size in megabytes (for ScaleServer - low limit)
        # vps_memory_max - maximum number of ScaleServer memory megabytes to scale up.
        # vps_hdd - Virtual HDD size im gigabytes.
        # vps_admin - support level (1 - usual&free, 2 - extended, 3 - VIP)
        # vps_os - OS ID to install
        # Output:
        # id - VDS ID
        # name - VDS title
        # imageId - OS ID 
        # adminPass - root password

        def create_server(image_id, options = {})
          data = {
            'server' => {
              :vps_os   => image_id,
              :vps_hdd => options[:vps_hdd]?options[:vps_hdd]:5,
              :vps_memory => options[:vps_memory]?options[:vps_memory]:256,
              :vps_memory_max => options[:vps_memory_max]?options[:vps_memory_max]:1024,
              :vps_admin => options[:vps_admin]?options[:vps_admin]:1
            }
          }

          data['server'].merge! options if options

          request(
                  :body     => MultiJson.encode(data),
                  :expects  => [200, 202],
                  :method   => 'POST',
                  :path     => 'servers'
                  )

        end

        class Mock
          def create_server(image_id, options = {})
            response = Excon::response.new
            response.status = 202

            data = {
              'id'        => Fog::Mock.random_numbers(6).to_i,
              'imageId'   => image_id,
              'name'      => options['name'] || "VPS #{rand(999)}",
              'adminPass'    => '23ryh8udbcbyt'
            }

            self.data[:last_modified][:servers][data['id']] = Time.now
            self.data[:servers][data['id']] = data
            response.body = { 'server' => data }
            response
          end
        end
      end
    end
  end
end
