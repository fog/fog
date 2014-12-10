module Fog
  module Compute
    class RackspaceV2
      class Real
        # The rebuild operation removes all data on the server and replaces it with the specified image.
        # The serverRef and all IP addresses remain the same. If you specify name, metadata, accessIPv4,
        # or accessIPv6 in the rebuild request, new values replace existing values. Otherwise, these values do not change.
        # @param [String] server_id id of the server to rebuild
        # @param [String] image_id id of image used to rebuild the server
        # @param [Hash] options
        # @option options [String] accessIPv4 The IP version 4 address.
        # @option options [String] accessIPv6 The IP version 6 address.
        # @option options [String] adminPass The administrator password.
        # @option options [Hash] metadata key value pairs of server metadata
        # @option options [String] OS-DCF:diskConfig The disk configuration value. (AUTO or MANUAL)
        # @option options [Hash] personality Hash containing data to inject into the file system of the cloud server instance during server creation.
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * server [Hash]:
        #       * name [String] - name of server
        #       * imageRef [String] - id of image used to create server
        #       * flavorRef [String] - id of flavor used to create server
        #       * OS-DCF:diskConfig [String] - The disk configuration value.
        #       * name [String] - name of server
        #       * metadata [Hash] - Metadata key and value pairs.
        #       * personality [Array]:
        #           * [Hash]:
        #             * path - path of the file created
        #             * contents - Base 64 encoded file contents
        #       * networks [Array]:
        #         * [Hash]:
        #           * uuid [String] - uuid of attached network
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Rebuild_Server-d1e3538.html
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Metadata-d1e2529.html
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Personality-d1e2543.html
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#diskconfig_attribute
        #
        # * Status Transition:
        #   * ACTIVE -> REBUILD -> ACTIVE
        #   * ACTIVE -> REBUILD -> ERROR (on error)
        def rebuild_server(server_id, image_id, options={})
          data = {
            'rebuild' => options || {}
          }
          data['rebuild']['imageRef'] = image_id

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def rebuild_server(server_id, image_id, options={})
          server = self.data[:servers][server_id]
          response(
            :body => {"server" => server},
            :status => 202
          )
        end
      end
    end
  end
end
