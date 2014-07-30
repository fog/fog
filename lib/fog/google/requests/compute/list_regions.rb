module Fog
  module Compute
    class Google
      class Mock
        def list_regions
          build_excon_response({
            "kind" => "compute#regionList",
            "selfLink" => "https://www.googleapis.com/compute/v1/projects/#{@project}/regions",
            "id" => "projects/#{@project}/regions",
            "items" => [
              {
                "kind" => "compute#region",
                "selfLink" => "https://www.googleapis.com/compute/v1/projects/#{@project}/regions/asia-east1",
                "id" => "2699746309412936080",
                "creationTimestamp" => "2014-01-28T04:12:16.138-08:00",
                "name" => "asia-east1",
                "description" => "asia-east1",
                "status" => "UP",
                "zones" => [
                  "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/asia-east1-a",
                  "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/asia-east1-b"
                ],
                "quotas" => [
                  { "metric" => "CPUS", "limit" => 24.0, "usage" => 0.0 },
                  { "metric" => "DISKS_TOTAL_GB", "limit" => 5120.0, "usage" => 0.0 },
                  { "metric" => "STATIC_ADDRESSES", "limit" => 7.0, "usage" => 0.0 },
                  { "metric" => "IN_USE_ADDRESSES", "limit" => 23.0, "usage" => 0.0 }
                ]
              },
              {
                "kind" => "compute#region",
                "selfLink" => "https://www.googleapis.com/compute/v1/projects/#{@project}/regions/europe-west1",
                "id" => "10546209748879352030",
                "creationTimestamp" => "2014-01-14T18:36:29.094-08:00",
                "name" => "europe-west1",
                "description" => "europe-west1",
                "status" => "UP",
                "zones" => [
                  "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/europe-west1-a",
                  "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/europe-west1-b"
                ],
                "quotas" => [
                  { "metric" => "CPUS", "limit" => 24.0, "usage" => 0.0 },
                  { "metric" => "DISKS_TOTAL_GB", "limit" => 5120.0, "usage" => 0.0 },
                  { "metric" => "STATIC_ADDRESSES", "limit" => 7.0,  "usage" => 0.0 },
                  { "metric" => "IN_USE_ADDRESSES", "limit" => 23.0, "usage" => 0.0 }
                ]
              },
              {
                "kind" => "compute#region",
                "selfLink" => "https://www.googleapis.com/compute/v1/projects/#{@project}/regions/us-central1",
                "id" => "17971001795365542305",
                "creationTimestamp" => "2014-01-14T18:36:29.094-08:00",
                "name" => "us-central1",
                "description" => "us-central1",
                "status" => "UP",
                "zones" => [
                  "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/us-central1-a",
                  "https://www.googleapis.com/compute/v1/projects/#{@project}/zones/us-central1-b"
                ],
                "quotas" => [
                  { "metric" => "CPUS", "limit" => 24.0, "usage" => 0.0 },
                  { "metric" => "DISKS_TOTAL_GB", "limit" => 5120.0, "usage" => 0.0 },
                  { "metric" => "STATIC_ADDRESSES", "limit" => 7.0,  "usage" => 0.0 },
                  { "metric" => "IN_USE_ADDRESSES", "limit" => 23.0, "usage" => 0.0 }
                ]
              }
            ]
          })
        end
      end

      class Real
        def list_regions
          api_method = @compute.regions.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
