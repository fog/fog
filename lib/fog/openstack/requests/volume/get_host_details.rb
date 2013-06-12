module Fog
  module Volume
    class OpenStack
      
      class Real
        def get_host_details(host_name)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "os-hosts/#{host_name}"
          )
        end
      end

      class Mock
        def get_host_details(host_name)
          Excon::Response.new(
            :status => 200,
            :body => {
              'host' => [
                {
                  'resource' => {
                    'volume_count' => '0', 
                    'total_volume_gb' => '0', 
                    'total_snapshot_gb' => '0', 
                    'project' => '(total)', 
                    'host' => host_name, 
                    'snapshot_count' => '0'
                  }
                }
              ]
            }
          )
        end
      end

    end
  end
end