module Fog
  module Compute
    class Google
      class Mock
        def list_disk_types(zone)
          build_excon_response({
            'kind' => 'compute#diskTypeList',
            'selfLink' => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}/diskTypes",
            'items' => [
              {
                'kind' => 'compute#diskType',
                'creationTimestamp' => '2014-06-02T18:07:28.530Z',
                'name' => 'pd-standard',
                'description' => 'Standard Persistent Disk',
                'validDiskSize' => '10GB-10TB',
                'zone' => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}",
                'selfLink' => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}/diskTypes/pd-standard",
              },
              {
                'kind' => 'compute#diskType',
                'creationTimestamp' => '2014-06-02T18:07:28.529Z',
                'name' => 'pd-ssd',
                'description' => 'SSD Persistent Disk',
                'validDiskSize' => '10GB-1TB',
                "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}",
                "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/zones/#{zone}/diskTypes/pd-ssd",
              }
            ]
          })
        end
      end

      class Real
        def list_disk_types(zone)
          api_method = @compute.disk_types.list
          parameters = {
            'project' => @project,
            'zone'    => zone.split('/')[-1],
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
