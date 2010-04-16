module Fog
  module Terremark
    module Shared
      module Real

        # Destroy an internet service
        #
        # ==== Parameters
        # * internet_service_id<~Integer> - Id of service to destroy
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
        def delete_internet_service(internet_service_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "InternetServices/#{internet_service_id}"
          )
        end

      end

      module Mock

        def delete_internet_service(internet_service_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
