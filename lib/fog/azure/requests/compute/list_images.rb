module Fog
  module Compute
    class Azure
      class Real
        def list_images
          @image_svc.list_virtual_machine_images
        end
      end

      class Mock
        def list_images
         []
        end
      end
    end
  end
end
