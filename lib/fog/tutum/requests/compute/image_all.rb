module Fog
  module Compute
    class Tutum
      class Real
        # List all images 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * 'objects'<~Array>:
        #     * 'name<~String> - Name of image
        #
        # ==== Filters
        #
        # offset (int) – optional, start the list skipping the first offset records (default: 0)
        # limit (int) – optional, only return at most limit records (default: 25, max: 100)
        # name (string) – optional, filter images by name
        # is_private_image (bool) – optional, display only private images
        # base_image (bool) – optional, display only Linux base images
        # starred (bool) – optional, display only jumpstart images
        # docker_registry__host (string) – optional, display only images stored in the specified host, i.e. r.tutum.co
        def image_all(filters = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "image/",
            :query    => filters
          )
        end
      end

      class Mock
        def image_all(filters = {})
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
                "base_image" => false,
                "cluster_aware" => false,
                "description" => "Test Image",
                "docker_registry" => "/api/v1/registry/r.tutum.co/",
                "image_url" => "",
                "imagetag_set" => [
                    "/api/v1/image/r.tutum.co/user/myimage/tag/latest/"
                ],
                "is_private_image" => true,
                "name" => "r.tutum.co/user/myimage",
                "public_url" => "",
                "resource_uri" => "/api/v1/image/r.tutum.co/user/myimaget/",
                "starred" => false
              }
            ]
          }
        end
      end
    end
  end
end
