module Fog
  module Terremark
    module Shared
      module Real

        # Destroy a vapp
        #
        # ==== Parameters
        # * vapp_id<~Integer> - Id of vapp to destroy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:

        # FIXME

        #     * 'CatalogItems'<~Array>
        #       * 'href'<~String> - linke to item
        #       * 'name'<~String> - name of item
        #       * 'type'<~String> - type of item
        #     * 'description'<~String> - Description of catalog
        #     * 'name'<~String> - Name of catalog
        def delete_vapp(vapp_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "vApp/#{vapp_id}"
          )
        end

      end

      module Mock

        def delete_vapp(vapp_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
