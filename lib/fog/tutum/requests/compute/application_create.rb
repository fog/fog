 module Fog
  module Compute
    class Tutum
      class Real
        def application_create(attrs)
          require_attr(:image, attrs)
          request(
            :expects  => [201],
            :method   => 'POST',
            :path     => "application/",
            :body     => JSON.encode(attrs)
          )
        end
      end

      class Mock
        def application_create(attrs)
          require_attr(:image, attrs)
          {
            "autodestroy" => "OFF",
            "autoreplace" => "OFF",
            "autorestart" => "OFF",
            "container_envvars" => [],
            "container_ports" => [
                {
                    "inner_port" => 80,
                    "outer_port" => nil,
                    "protocol" => "tcp"
                }
            ],
            "container_size" => "XS",
            "containers" => [
                "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/"
            ],
            "current_num_containers" => 2,
            "deployed_datetime" => nil,
            "destroyed_datetime" => nil,
            "entrypoint" => "",
            "image_name" => "tutum/hello-world:latest",
            "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables" => {
                "MY_AWESOME_APP_TUTUM_API_URL" => "https://app.tutum.co/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/"
            },
            "linked_from_application" => [],
            "linked_to_application" => [
                {
                    "to_application" => "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
                    "name" => "db"
                }
            ],
            "linked_from_container" => [],
            "linked_to_container" => [],
            "name" => "my-awesome-app",
            "sequential_deployment" => false,
            "public_dns" => "my-awesome-app-admin.dev.tutum.io",
            "resource_uri" => "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "roles" => [],
            "run_command" => "/run.sh",
            "running_num_containers" => 0,
            "started_datetime" => nil,
            "state" => "Starting",
            "stopped_datetime" => nil,
            "stopped_num_containers" => 0,
            "target_num_containers" => 2,
            "unique_name" => "my-awesome-app",
            "uuid" => "1f234d1d-dae5-46c1-9ee5-770575fe3e6f",
            "web_public_dns" => "awesome-app.example.com"
          }
        end
      end
    end
  end
end
