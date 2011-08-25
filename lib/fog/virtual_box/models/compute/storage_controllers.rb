require 'fog/core/collection'
require 'fog/virtual_box/models/compute/storage_controller'

module Fog
  module Compute
    class VirtualBox

      class StorageControllers < Fog::Collection

        model Fog::Compute::VirtualBox::StorageController

        attr_accessor :machine

        def all
          requires :machine
          data = machine.instance_variable_get(:@raw).storage_controllers.map do |storage_controller|
            {:raw => storage_controller}
          end
          load(data)
        end

        def get(storage_controller_name)
          requires :machine
          all.detect do |storage_controller|
            storage_controller.name == storage_controller_name
          end
        end

        def new(attributes = {})
          requires :machine
          super({ :machine => machine }.merge!(attributes))
        end

      end

    end
  end
end
