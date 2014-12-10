module Fog
  module Compute
    class RackspaceV2
      class Real
        # Create an image from a running server
        #
        # @param [String] server_id Id of server to create image from
        # @param [String] name name for created image
        # @param [Hash] options
        # @option options [Hash] :metadata - key value pairs of image metadata
        # @return [Excon::Response] response
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Create_Image-d1e4655.html
        #
        # * State Transition:
        #   * SAVING -> ACTIVE
        #   * SAVING  -> ERROR (on error)
        def create_image(server_id, name, options = {})
          data = {
            'createImage' => {
              'name' => name
            }
          }
          data['createImage'].merge!(options)
          request(
            :body     => Fog::JSON.encode(data),
            :expects  => 202,
            :method   => 'POST',
            :path     => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def create_image(server_id, name, options = {})
          image_id = Fog::Rackspace::MockData.uuid
          image = {
            "OS-DCF:diskConfig" => "AUTO",
            "created"           => "2012-02-28T19:38:57Z",
            "id"                => image_id,
            "links"             => [
              {
                "href"              => "https://dfw.servers.api.rackspacecloud.com/v2/010101/images/#{image_id}",
                "rel"               => "self"
              },
              {
                "href"              => "https://dfw.servers.api.rackspacecloud.com/010101/images/#{image_id}",
                "rel"               => "bookmark"
              },
              {
                "href"              => "https://dfw.servers.api.rackspacecloud.com/010101/images/#{image_id}",
                "rel"               => "alternate",
                "type"              => "application/vnd.openstack.image"
              }
            ],
            "metadata"                              => {
              "arch"                                  => "x86-64",
              "auto_disk_config"                      => "True",
              "com.rackspace__1__build_core"          => "1",
              "com.rackspace__1__build_managed"       => "0",
              "com.rackspace__1__build_rackconnect"   => "0",
              "com.rackspace__1__options"             => "0",
              "com.rackspace__1__visible_core"        => "1",
              "com.rackspace__1__visible_managed"     => "0",
              "com.rackspace__1__visible_rackconnect" => "0",
              "image_type"                            => "base",
              "org.openstack__1__architecture"        => "x64",
              "org.openstack__1__os_distro"           => "org.ubuntu",
              "org.openstack__1__os_version"          => "11.10",
              "os_distro"                             => "ubuntu",
              "os_type"                               => "linux",
              "os_version"                            => "11.10",
              "rax_managed"                           => "false",
              "rax_options"                           => "0"
            },
            "minDisk"  => 10,
            "minRam"   => 256,
            "name"     => "Ubuntu 11.10",
            "progress" => 100,
            "status"   => "SAVING",
            "updated"  => "2012-02-28T19:39:05Z"
          }

          self.data[:images][image_id] = image

          response(
            :status => 202,
            :headers => {"Location" => "/#{image_id}"}
          )
        end
      end
    end
  end
end
