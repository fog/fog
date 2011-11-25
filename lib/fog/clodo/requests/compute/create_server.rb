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
      end

      class Mock
        def create_server(image_id, options = {})

          raise Excon::Errors::BadRequest.new("Invalid image ID") unless image_id > 0

          response = Excon::Response.new
          response.status = 202

          id = Fog::Mock.random_numbers(6).to_i

          data = {
            'id'        => id,
            'imageId'   => "#{image_id}",
            'name'      => options['name'] || "VPS #{rand(999)}",
            'adminPass'    => '23ryh8udbcbyt'
          }

          self.data[:last_modified][:servers][id] = Time.now
          self.data[:servers][id] = {
            'id' => "#{id}",
            'imageId' => data['imageId'],
            'name' => data['name'],
            'vps_os_title' => "OSTitle",
            'vps_root_pass' => data['adminPass'],
            'status' => "is_running",
            'addresses' => {'public' =>[{
                                          'primary_ip' => true,
                                          'isp' => false,
                                          'ip' => '66.6.6.66'
                                        },
                                        {
                                          'primary_ip' => false,
                                          'isp' => false,
                                          'ip' => '13.13.13.13'
                                        }]},
            'vps_createdate' => "#{Time.now}",
            'vps_hdd_max' => "5",
            'vps_traff' => nil,
            'vps_mem_1h_max' => "0",
            'vps_mem_load' => "0",
            'vps_user_pass' => "wer45345ht",
            'vps_vnc_pass' => "bi65tdfyb",
            'vps_adddate' => "#{Time.now}",
            'vps_update' => "#{Time.now}",
            'vps_mem_1h_min' => "0",
            'vps_mem_1h_avg' => nil,
            'vps_memory_max' => options['vps_memory_max'] || "512",
            'vps_os_version' => "6.6.6",
            'vps_cpu_1h_max' => "0",
            'vps_hdd_load' => "0",
            'vps_disk_load' => "0",
            'vps_os_type' => options['vps_os_type'] || "VirtualServer",
            'type' => options['vps_os_type'] || "VirtualServer",
            'vps_memory' => options['vps_memory'] || "512",
            'vps_cpu_load' => "0",
            'vps_update_days' => "0",
            'vps_os_bits' => "64",
            'vps_vnc' => "6.6.6.6:5900",
            'vps_cpu_max' => "0",
            'vps_cpu_1h_min' => "0",
            'vps_cpu_1h_avg' => nil
          }

          response.body = { 'server' => data }
          response
        end
      end
    end
  end
end

