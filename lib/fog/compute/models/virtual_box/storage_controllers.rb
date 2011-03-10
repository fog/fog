require 'fog/core/collection'
require 'fog/compute/models/virtual_box/storage_controller'

module Fog
  module VirtualBox
    class Compute

      class StorageControllers < Fog::Collection

        model Fog::VirtualBox::Compute::StorageController

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
