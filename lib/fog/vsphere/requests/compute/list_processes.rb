module Fog
  module Compute
    class Vsphere
      class Real
        def list_processes(vm_id, opts)
          vm = get_vm_ref(vm_id)

          auth = RbVmomi::VIM::NamePasswordAuthentication(
            username: opts[:user],
            password: opts[:password],
            interactiveSession: false
          )

          p_manager = @connection.serviceContent.guestOperationsManager.processManager
          processes = p_manager.ListProcessesInGuest(vm: vm, auth: auth)
          processes.map do |pi|
            Process.new(
              cmd_line: pi.cmdLine,
              end_time: pi.endTime,
              exit_code: pi.exitCode,
              name: pi.name,
              owner: pi.owner,
              pid: pi.pid,
              start_time: pi.startTime
            )
          end
        end
      end

      class Mock
        def list_processes(vm_id, opts = {})
          [
            Process.new(name: 'winlogon'),
            Process.new(name: 'init')
          ]
        end
      end
    end
  end
end

