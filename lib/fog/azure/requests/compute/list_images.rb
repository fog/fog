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
          image = ::Azure::VirtualMachineManagement::VirtualMachine.new
          image.name = 'Ubuntu-13_04-amd64-server-20130601-en-us-30GB'
          image.os_type = 'Linux'
          image.category = 'Public'
          image.locations = 'East Asia;Southeast Asia;North Europe'
          [image]
        end

      end

    end
  end
end
