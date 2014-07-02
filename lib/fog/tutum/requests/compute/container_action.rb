module Fog
  module Compute
    class Tutum
      class Real
        def container_action(attrs = {})
          require_attr(:uuid, attrs)
          require_attr(:action, attrs)

          uuid = attrs[:uuid]
          action = attrs[:action]
          body = JSON.encode(attrs.reject {|k,v| [:uuid, :action].include? k })
          request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "container/#{uuid}/#{action}/",
            :body     => body
          )
        end
      end

      class Mock
        def container_action(attrs = {})
          require_attr(:uuid, attrs)
          require_attr(:action, attrs)
          {
            "application" => "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy" => "OFF",
            "autoreplace" => "OFF",
            "autorestart" => "OFF",
            "container_envvars" => [
                {
                    "key" => "MY_AWESOME_APP_1_PORT",
                    "value" => "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "key" => "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value" => "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "key" => "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value" => "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "key" => "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value" => "49221"
                },
                {
                    "key" => "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value" => "tcp"
                }
            ],
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
            "link_variables" => {
                "MY_AWESOME_APP_2_PORT" => "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP" => "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR" => "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT" => "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO" => "tcp"
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
            "public_dns" => "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri" => "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles" => [],
            "run_command" => "/run.sh",
            "started_datetime" => "Sun, 6 Apr 2014 18:11:22 +0000",
            "state" => "Stopping",
            "stopped_datetime" => nil,
            "unique_name" => "my-awesome-app-2",
            "uuid" => "f5d64083-7698-4aec-b5dc-86a48be0f565"
          }
        end
      end
    end
  end
end
