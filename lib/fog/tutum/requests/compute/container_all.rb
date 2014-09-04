module Fog
  module Compute
    class Tutum
      class Real
        # List all containers 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'objects'<~Array>:
        #     * 'id'<~Integer> - Id of container
        #     * 'name<~String> - Name of container
        #
        # ==== Filters
        #
        # offset (int) – optional, start the list skipping the first offset records (default: 0)
        # limit (int) – optional, only return at most limit records (default: 25, max: 100)
        # unique_name (string) – optional, filter containers by name
        # uuid (string) – optional, filter containers by uuid
        # uuid__startswith (string) – optional, filter containers by uuids that start with the given string
        # state (string) – optional, filter containers by state
        # application__name (string) – optional, filter containers by application name
        # application__uuid (string) – optional, filter containers by application uuid
        # application__state (string) – optional, filter containers by application state
        def container_all(filters = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "container/",
            :query    => filters
          )
        end
      end

      class Mock
        def container_all(filters = {})
          {
            "meta" => {
                "limit" => 25,
                "next" => nil,
                "offset" => 0,
                "previous" => nil,
                "total_count" => 2
            },
            "objects" => [
                {
                    "application" => "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "autodestroy" => "OFF",
                    "autoreplace" => "OFF",
                    "autorestart" => "OFF",
                    "container_ports" => [
                        {
                            "inner_port" => 80,
                            "outer_port" => 49221,
                            "protocol" => "tcp"
                        }
                    ],
                    "container_size" => "XS",
                    "deployed_datetime" => "Sun, 6 Apr 2014 18:11:17 +0000",
                    "destroyed_datetime" => nil,
                    "entrypoint" => "",
                    "exit_code" => nil,
                    "exit_code_msg" => nil,
                    "image_name" => "tutum/hello-world:latest",
                    "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name" => "my-awesome-app",
                    "public_dns" => "my-awesome-app-1-admin.alpha-dev.tutum.io",
                    "resource_uri" => "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                    "run_command" => "/run.sh",
                    "started_datetime" => "Sun, 6 Apr 2014 18:11:17 +0000",
                    "state" => "Running",
                    "stopped_datetime" => nil,
                    "unique_name" => "my-awesome-app-1",
                    "uuid" => "4a7c672c-4f55-4417-9300-c932eabe7f7e"
                },
                {
                    "application" => "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "autodestroy" => "OFF",
                    "autoreplace" => "OFF",
                    "autorestart" => "OFF",
                    "container_ports" => [
                        {
                            "inner_port" => 80,
                            "outer_port" => 49222,
                            "protocol" => "tcp"
                        }
                    ],
                    "container_size" => "XS",
                    "deployed_datetime" => "Sun, 6 Apr 2014 18:11:22 +0000",
                    "destroyed_datetime" => nil,
                    "entrypoint" => "",
                    "exit_code" => nil,
                    "exit_code_msg" => nil,
                    "image_name" => "tutum/hello-world:latest",
                    "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name" => "my-awesome-app",
                    "public_dns" => "my-awesome-app-2-admin.alpha-dev.tutum.io",
                    "resource_uri" => "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "run_command" => "/run.sh",
                    "started_datetime" => "Sun, 6 Apr 2014 18:11:22 +0000",
                    "state" => "Running",
                    "stopped_datetime" => nil,
                    "unique_name" => "my-awesome-app-2",
                    "uuid" => "f5d64083-7698-4aec-b5dc-86a48be0f565"
                }
            ]
          }
        end
      end
    end
  end
end
