#
#   Copyright (c) 2012 VMware, Inc. All Rights Reserved.
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

module Fog
    module Vsphere
      module Utility

        TASK_POLL_INTERVAL = 2

        def wait_for_task(task)
          state = task.info.state
          while (state != 'error') and (state != 'success')
            sleep(TASK_POLL_INTERVAL)
            state = task.info.state
          end

          case state
            when 'success'
              task.info.result
            when 'error'
              raise task.info.error
          end
        end

        def keep_alive_util(conn)
          conn.serviceInstance.CurrentTime
        end
     end
  end
end
