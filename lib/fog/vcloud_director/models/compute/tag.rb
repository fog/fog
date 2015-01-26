require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector
      class Tag < Model
        identity  :id
        attribute :value

        def value=(new_value)
          has_changed = ( value != new_value )
          not_first_set = !value.nil?
          attributes[:value] = new_value
          if not_first_set && has_changed
            response = service.put_vapp_metadata_item_metadata(vm.id, id, value)
            service.process_task(response.body)
          end
        end

        def destroy
          response = service.delete_vapp_metadata_item_metadata(vm.id, id)
          service.process_task(response.body)
        end

        def vm
          attributes[:vm]
        end
      end
    end
  end
end
