module Fog
  module Compute
    class Vsphere

      module Shared
        def wait_for_task(task)
          state = task.info.state
          while (state != 'error') and (state != 'success')
            sleep(2)
            state = task.info.state
          end
          case state
            when 'success'
              task.info.result
            when 'error'
              raise task.info.error
          end
        end

        def get_ds_name_by_path(vmdk_path)
          path_elements = vmdk_path.split('[').tap { |ary| ary.shift }
          template_ds = path_elements.shift
          template_ds = template_ds.split(']')
          datastore_name = template_ds[0]
          datastore_name
        end

      end

      class Real
        include Shared
      end

      class Mock
        include Shared
      end

    end
  end
end
