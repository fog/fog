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
