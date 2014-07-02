module Fog
  module Compute
    class Tutum
      class Real
        def image_create(attrs)
          require_attr(:name, attrs)
          require_attr(:username, attrs)
          require_attr(:password, attrs)
          request(
            :expects  => [202],
            :method   => 'POST',
            :path     => "image/",
            :body     => JSON.encode(attrs)
          )
        end
      end

      class Mock
        def image_create(attrs)
          require_attr(:name, attrs)
          require_attr(:username, attrs)
          require_attr(:password, attrs)
          {
            "base_image" => false,
            "cluster_aware" => false,
            "description" => "",
            "docker_registry" => {
                "host" => "quay.io",
                "image_url" => "https://dzu352mg2ppy3.cloudfront.net/assets/images/dockerregistries/quay.ico",
                "is_tutum_registry" => false,
                "name" => "Quay.io",
                "resource_uri" => "/api/v1/registry/quay.io/",
                "uuid" => "8df846ff-897d-4c87-bfb3-dc0ede3e8dd4"
            },
            "image_url" => "",
            "imagetag_set" => [
                {
                    "full_name" => "quay.io/user/my-private-image:latest",
                    "image" => {
                        "author" => "User <user@example.com>",
                        "docker_id" => "9cd978db300e27386baa9dd791bf6dc818f13e52235b56e95703361ec3c94dc6",
                        "entrypoint" => "",
                        "image_creation" => "Mon, 3 Feb 2014 17:22:29 +0000",
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
                        "imageport_set" => [],
                        "run_command" => ""
                    },
                    "image_info" => "/api/v1/image/quay.io/user/my-private-image/",
                    "name" => "latest",
                    "resource_uri" => "/api/v1/image/quay.io/user/my-private-image/tag/latest/"
                }
            ],
            "is_private_image" => true,
            "name" => "quay.io/tutum/test-repo3",
            "public_url" => "https://quay.io/repository/user/my-private-image",
            "resource_uri" => "/api/v1/image/quay.io/user/my-private-image/",
            "starred" => false
          }
        end
      end
    end
  end
end
