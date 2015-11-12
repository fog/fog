module Fog
  module Compute
    class Vsphere
      class Real
        # NOTE: you must be using vsphere_rev 5.0 or greater to use this functionality
        # e.g. Fog::Compute.new(provider: "vsphere", vsphere_rev: "5.5", etc)
        # * options<~Hash>:
        #   * 'instance_uuid'<~String> - *REQUIRED* the instance uuid you would like to operate on
        #   * 'command'<~String> *REQUIRED* the command to execute
        #   * 'args'<~String> arguments to pass the command
        #   * 'working_dir'<~String> path to the working directory
        #   * 'user'<~String> *REQUIRED* the ssh username you would like to login as
        #   * 'password'<~String> *REQUIRED* the ssh password for the user you would like to log in as
        def vm_execute(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          raise ArgumentError, "command is a required parameter" unless options.key? 'command'
          raise ArgumentError, "user is a required parameter" unless options.key? 'user'
          raise ArgumentError, "password is a required parameter" unless options.key? 'password'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first

          auth = RbVmomi::VIM::NamePasswordAuthentication(:interactiveSession => false,
                                                          :username => options['user'],
                                                          :password => options['password'])

          spec = RbVmomi::VIM::GuestProgramSpec(:programPath => options['command'],
                                                :arguments => options['args'],
                                                :workingDirectory => options['working_dir'])

          gom = @connection.serviceContent.guestOperationsManager
          gom.processManager.StartProgramInGuest(:vm => vm_mob_ref, :auth => auth, :spec => spec)
        end
      end

      class Mock
        def vm_execute(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          raise ArgumentError, "command is a required parameter" unless options.key? 'command'
          raise ArgumentError, "user is a required parameter" unless options.key? 'user'
          raise ArgumentError, "password is a required parameter" unless options.key? 'password'
          return 12345
        end
      end
    end
  end
end
