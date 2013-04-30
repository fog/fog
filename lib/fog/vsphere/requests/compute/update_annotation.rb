module Fog
  module Compute
    class Vsphere
      class Real
        def update_annotation(vm_id, key, val)

          # fetch VM
          search_filter = { :uuid => vm_id, 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          # set annotation
          vm_mob_ref.setCustomValue(:key => key, :value => val)

        end
      end

      class Mock

        def update_annotation(vm_id, key, val)
        end
      end
    end
  end
end
