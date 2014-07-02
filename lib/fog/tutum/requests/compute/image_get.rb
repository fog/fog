module Fog
  module Compute
    class Tutum
      class Real
        def image_get(name)          
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "image/#{name}/"
          )
        end
      end
      class Mock
        def image_get(name)
          {
            "base_image" => false,
            "cluster_aware" => false,
            "description" => "",
            "docker_registry" => {
                "host" => "index.docker.io",
                "image_url" => "",
                "is_tutum_registry" => false,
                "name" => "index.docker.io",
                "resource_uri" => "/api/v1/registry/index.docker.io/",
                "uuid" => "c6d617c1-5421-4e09-a2b3-dc05b77ffdbb"
            },
            "image_url" => "",
            "imagetag_set" => [
                {
                    "full_name" => "tutum/lamp:latest",
                    "image" => {
                        "author" => "Fernando Mayo",
                        "docker_id" => "34ead373df921d5d28226e7a6795280f4f33bbfdf7ca0bc9c98a3e431a8f2e44",
                        "entrypoint" => "",
                        "image_creation" => "Thu, 6 Mar 2014 11:10:37 +0000",
                        "imageenvvar_set" => [
                            {
                                "key" => "HOME",
                                "value" => "/"
                            },
                            {
                                "key" => "PATH",
                                "value" => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
                            }
                        ],
                        "imageport_set" => [
                            {
                                "port" => 80,
                                "protocol" => "tcp"
                            },
                            {
                                "port" => 3306,
                                "protocol" => "tcp"
                            }
                        ],
                        "run_command" => "/run.sh"
                    },
                    "image_info" => "/api/v1/image/tutum/lamp/",
                    "name" => "latest",
                    "resource_uri" => "/api/v1/image/tutum/lamp/tag/latest/"
                }
            ],
            "is_private_image" => false,
            "name" => "tutum/lamp",
            "public_url" => "https://index.docker.io/u/tutum/lamp/",
            "resource_uri" => "/api/v1/image/tutum/lamp/",
            "starred" => false
          }
        end
      end
    end
  end
end
