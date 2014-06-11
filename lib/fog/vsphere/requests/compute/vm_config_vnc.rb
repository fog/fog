module Fog
  module Compute
    class Vsphere
      class Real
        def vm_config_vnc(options = { })
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref    = @connection.searchIndex.FindAllByUuid(search_filter).first
          task          = vm_mob_ref.ReconfigVM_Task(:spec => {
            :extraConfig => [
              { :key => 'RemoteDisplay.vnc.enabled',  :value => options[:enabled] ? 'true' : 'false' },
              { :key => 'RemoteDisplay.vnc.password', :value => options[:password].to_s },
              { :key => 'RemoteDisplay.vnc.port',     :value => options[:port].to_s || '5910' }
            ]
          })
          task.wait_for_completion
          { 'task_state' => task.info.state }
        end

        # return a hash of VNC attributes required to view the console
        def vm_get_vnc uuid
          search_filter = { :uuid => uuid, 'vmSearch' => true, 'instanceUuid' => true }
          vm = @connection.searchIndex.FindAllByUuid(search_filter).first
          Hash[vm.config.extraConfig.map do |config|
            if config.key =~ /^RemoteDisplay\.vnc\.(\w+)$/
              [$1.to_sym, config.value]
            end
          end.compact]
        end
      end

      class Mock
        def vm_config_vnc(options = { })
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          { 'task_state' => 'success' }
        end

        def vm_get_vnc uuid
          {:password => 'secret', :port => '5900', :enabled => 'true'}
        end
      end
    end
  end
end
