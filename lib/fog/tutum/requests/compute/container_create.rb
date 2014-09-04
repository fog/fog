module Fog
  module Compute
    class Tutum
      class Real
        def container_create(image, attrs = {})
          attrs = { :image => image }.merge(attrs)
          request(
            :expects  => [201],
            :method   => 'POST',
            :path     => "container/",
            :body     => JSON.encode(attrs)
          )
        end
      end

      class Mock
        def container_create(image, attrs = {})
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
              "deployed_datetime" => nil,
              "destroyed_datetime" => nil,
              "entrypoint" => "",
              "image_name" => "tutum/hello-world:latest",
              "image_tag" => "/api/v1/image/tutum/hello-world/tag/latest/",
              "link_variables" => {
                  "MY_AWESOME_APP_TUTUM_API_URL" => "https://app.tutum.co/api/v1/container/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/"
              },
              "linked_from_application" => [],
              "linked_to_application" => [],
              "linked_from_container" => [],
              "linked_to_container" => [],
              "name" => "my-awesome-app",
              "public_dns" => "my-awesome-app-admin.dev.tutum.io",
              "resource_uri" => "/api/v1/container/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
              "roles" => [],
              "run_command" => "/run.sh",
              "started_datetime" => nil,
              "state" => "Init",
              "stopped_datetime" => nil,
              "unique_name" => "my-awesome-app",
              "uuid" => "1f234d1d-dae5-46c1-9ee5-770575fe3e6f",
              "web_public_dns" => "awesome-app.example.com"
          }
        end
      end
    end
  end
end
