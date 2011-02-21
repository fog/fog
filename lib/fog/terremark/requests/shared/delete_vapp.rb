module Fog
  module Terremark
    module Shared
      module Real

        # Destroy a vapp
        #
        # ==== Parameters
        # * vapp_id<~Integer> - Id of vapp to destroy
        #
        def delete_vapp(vapp_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "vApp/#{vapp_id}"
          )
        end

      end
    end
  end
end
