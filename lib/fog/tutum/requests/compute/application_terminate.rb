module Fog
  module Compute
    class Tutum
      class Real
        def application_terminate(uuid)
          request(
            :expects  => [202],
            :method   => 'DELETE',
            :path     => "application/#{uuid}/"
          )
        end
      end

      class Mock
        def application_terminate(uuid)
          {
            "autodestroy" => "OFF",
            "autoreplace" => "ALWAYS",
            "autorestart" => "ALWAYS",
            "container_envvars" => [
                {
                    "key" => "ENVIRONMENT",
                    "value" => "dev"
                }
            ],
            "container_ports" => [
                {
                    "inner_port" => 80,
                    "outer_port" => nil,
                    "protocol" => "tcp"
                }
            ],
            "container_size" => "XS",
            "containers" => [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers" => 3,
            "deployed_datetime" => "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime" => nil,
            "entrypoint" => "",
            "image_name" => "tutum/hello-world:latest",
            "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables" => {
                "MY_WEB_APP_TUTUM_API_URL" => "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
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
            "name" => "my-web-app",
            "sequential_deployment" => false,
            "public_dns" => "my-web-app-admin.dev.tutum.io",
            "resource_uri" => "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles" => [],
            "run_command" => "/run.sh",
            "running_num_containers" => 0,
            "started_datetime" => "Sun, 6 Apr 2014 18:23:56 +0000",
            "state" => "Terminating",
            "stopped_datetime" => "Sun, 6 Apr 2014 18:21:22 +0000",
            "stopped_num_containers" => 0,
            "target_num_containers" => 3,
            "unique_name" => "my-web-app",
            "uuid" => "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns" => "myapp.example.com"
          }
        end
      end
    end
  end
end
