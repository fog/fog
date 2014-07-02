module Fog
  module Compute
    class Tutum
      class Real
        # List all applications 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'objects'<~Array>:
        #     * 'uuid'<~Integer> - Id of application
        #     * 'name<~String> - Name of application
        #
        # ==== Filters
        #
        # offset (int) – optional, start the list skipping the first offset records (default: 0)
        # limit (int) – optional, only return at most limit records (default: 25, max: 100)
        # name (string) – optional, filter applications by name
        # uuid (string) – optional, filter applications by UUID
        # uuid__startswith (string) – optional, filter applications by UUIDs that start with the given string
        # state (string) – optional, filter applications by state

        APPLICATION_ALL_ALLOWED_FILTERS = [:offset, 
                           :limit, 
                           :unique_name, 
                           :uuid, 
                           :uuid__startswith, 
                           :state]

        def application_all(filters = {})
          query_params = build_query_string(limit_filters(IMAGE_ALL_ALLOWED_FILTERS, filters))

          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "application/#{query_params}"
          )
        end
      end
      class Mock
        def application_all(filters = {})
          {
            "meta" => {
                "limit" => 25,
                "next" => nil,
                "offset" => 0,
                "previous" => nil,
                "total_count" => 1
            },
            "objects" => [
                {
                    "autodestroy" => "OFF",
                    "autoreplace" => "ALWAYS",
                    "autorestart" => "ALWAYS",
                    "container_ports" => [
                        {
                            "inner_port" => 80,
                            "outer_port" => nil,
                            "protocol" => "tcp"
                        }
                    ],
                    "container_size" => "XS",
                    "current_num_containers" => 2,
                    "deployed_datetime" => "Sun, 6 Apr 2014 17:59:42 +0000",
                    "destroyed_datetime" => nil,
                    "entrypoint" => "",
                    "image_name" => "tutum/hello-world:latest",
                    "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name" => "my-web-app",
                    "public_dns" => "my-web-app-admin.dev.tutum.io",
                    "resource_uri" => "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "run_command" => "/run.sh",
                    "running_num_containers" => 2,
                    "sequential_deployment" => false,
                    "started_datetime" => "Sun, 6 Apr 2014 17:59:42 +0000",
                    "state" => "Running",
                    "stopped_datetime" => nil,
                    "stopped_num_containers" => 0,
                    "target_num_containers" => 2,
                    "unique_name" => "my-web-app",
                    "uuid" => "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
                    "web_public_dns" => "myapp.example.com"
                }
            ]
          }
        end
      end
    end
  end
end
