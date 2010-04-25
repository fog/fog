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
            :path     => "publicIps/#{public_ip_id}"
          )
        end

      end

      module Mock

        def delete_public_ip(public_ip_id)
          raise MockNotImplemented.new("Contributions welcome!")
        end

      end
    end
  end
end
