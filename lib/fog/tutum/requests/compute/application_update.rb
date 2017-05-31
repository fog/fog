module Fog
  module Compute
    class Tutum
      class Real
        def application_update(uuid, attrs)
          request(
            :expects  => [202],
            :method   => 'PATCH',
            :path     => "application/#{uuid}/",
            :body     => JSON.encode(attrs)
          )
        end
      end

      class Mock
        def application_update(uuid, attrs)
          {
            "target_num_containers" => 3,
            "deployed_datetime" => "Sun, 6 Apr 2014 17:59:42 +0000",
            "container_ports" => [
                {
                    "outer_port" => nil,
                    "inner_port" => 80,
                    "protocol" => "tcp"
                }
            ],
            "current_num_containers" => 3,
            "run_command" => "/run.sh",
            "autodestroy" => "OFF",
            "linked_to_application" => [
                {
                    "to_application" => "/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/",
                    "name" => "db"
                }
            ],
            "container_size" => "XS",
            "started_datetime" => "Sun, 6 Apr 2014 17:59:42 +0000",
            "stopped_num_containers" => 0,
            "uuid" => "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "name" => "my-web-app",
            "sequential_deployment" => false,
            "autorestart" => "ALWAYS",
            "destroyed_datetime" => nil,
            "state" => "Scaling",
            "roles" => [],
            "containers" => [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "image_name" => "tutum/hello-world:latest",
            "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
            "running_num_containers" => 2,
            "resource_uri" => "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "stopped_datetime" => nil,
            "unique_name" => "my-web-app",
            "linked_from_application" => [],
            "linked_from_container" => [],
            "linked_to_container" => [],
            "web_public_dns" => "myapp.example.com",
            "entrypoint" => "",
            "public_dns" => "my-web-app-admin.dev.tutum.io",
            "container_envvars" => [
                {
                    "key" => "ENVIRONMENT",
                    "application" => "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "value" => "dev"
                }
            ],
            "autoreplace" => "ALWAYS",
            "link_variables" => {
                "MY_WEB_APP_2_PORT_80_TCP" => "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
                "MY_WEB_APP_TUTUM_API_URL" => "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                "MY_WEB_APP_2_PORT" => "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
                "MY_WEB_APP_1_PORT_80_TCP_PROTO" => "tcp",
                "MY_WEB_APP_1_PORT" => "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
                "MY_WEB_APP_1_PORT_80_TCP_PORT" => "49219",
                "MY_WEB_APP_2_PORT_80_TCP_PORT" => "49220",
                "MY_WEB_APP_2_PORT_80_TCP_PROTO" => "tcp",
                "MY_WEB_APP_1_PORT_80_TCP" => "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
                "MY_WEB_APP_1_PORT_80_TCP_ADDR" => "my-web-app-1-admin.alpha-dev.tutum.io",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR" => "my-web-app-2-admin.alpha-dev.tutum.io"
            }
          }
        end
      end
    end
  end
end
