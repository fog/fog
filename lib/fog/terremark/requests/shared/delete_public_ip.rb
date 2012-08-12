module Fog
  module Terremark
    module Shared
      module Real

        # Destroy a public ip
        #
        # ==== Parameters
        # * public_ip_id<~Integer> - Id of public ip to destroy
        #
        def delete_public_ip(public_ip_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "api/extensions/v1.6/publicIp/#{public_ip_id}",
            :override_path => true
          )
        end

      end
    end
  end
end
