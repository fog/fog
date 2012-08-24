module Fog
  module Terremark
    module Shared
      module Real

        # Destroy an internet service
        #
        # ==== Parameters
        # * internet_service_id<~Integer> - Id of service to destroy
        #
        def delete_internet_service(internet_service_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "api/extensions/v1.6/internetService/#{internet_service_id}",
            :override_path => true
          )
        end

      end
    end
  end
end
