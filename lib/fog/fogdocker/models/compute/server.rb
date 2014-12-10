require 'fog/compute/models/server'

module Fog
  module Compute
    class Fogdocker
      # fog server is a docker container
      class Server < Fog::Compute::Server
        identity :id

        attr_accessor :info

        attribute :name
        attribute :created
        attribute :path
        attribute :args
        attribute :hostname
        attribute :links,                       :aliases => 'hostconfig_links'
        attribute :privileged,                  :aliases => 'hostconfig_privileged'
        attribute :port_bindings,               :aliases => 'hostconfig_port_bindings'
        attribute :ipaddress,                   :aliases => 'network_settings_ipaddress'
        attribute :bridge,                      :aliases => 'network_settings_bridge'
        attribute :state_running
        attribute :state_pid
        attribute :state_exit_code
        attribute :cores,                       :aliases => 'config_cpu_sets'
        attribute :cpu_shares,                  :aliases => 'config_cpu_shares'
        attribute :memory,                      :aliases => 'config_memory'
        attribute :hostname,                    :aliases => 'config_hostname'
        attribute :cmd,                         :aliases => 'config_cmd'
        attribute :entrypoint,                  :aliases => 'config_entrypoint'
        attribute :tty,                         :aliases => 'config_tty'
        attribute :attach_stdin,                :aliases => 'config_attach_stdin'
        attribute :attach_stdout,               :aliases => 'config_attach_stdout'
        attribute :attach_stderr,               :aliases => 'config_attach_stderr'
        attribute :host
        attribute :image
        attribute :exposed_ports,               :aliases => 'config_exposed_ports'
        attribute :volumes
        attribute :environment_variables,       :aliases => 'config_env'

        #raw = {"ID"=>"2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650",
        # "Created"=>"2014-01-16T12:42:38.081665295Z",
        # "Path"=>"/bin/bash",
        # "Args"=>[],
        # "Config"=>{
        #     "Hostname"=>"2ce79789656e",
        #     "Domainname"=>"",
        #     "User"=>"",
        #     "Memory"=>0,
        #     "MemorySwap"=>0,
        #     "CpuShares"=>0,
        #     "AttachStdin"=>true,
        #     "AttachStdout"=>true,
        #     "AttachStderr"=>true,
        #     "PortSpecs"=>nil,
        #     "ExposedPorts"=>{},
        #     "Env": [
        #         "HOME=/mydir",
        #     ],
        # "State"=>{
        #     "Running"=>true,
        #     "Pid"=>1505,
        #     "ExitCode"=>0,
        #     "StartedAt"=>"2014-01-16T15:50:36.304626413Z",
        #     "FinishedAt"=>"2014-01-16T15:50:36.238743161Z",
        #     "Ghost"=>false},
        # "Image"=>"7c8cf65e1efa9b55f9ba8c60a970fe41595e56b894c7fdb19871bd9b276ca9d3",
        # "NetworkSettings"=>{
        #     "IPAddress"=>"172.17.0.2",
        #     "IPPrefixLen"=>16,
        #     "Gateway"=>"172.17.42.1",
        #     "Bridge"=>"docker0",
        #     "PortMapping"=>nil,
        #     "Ports"=>{}},
        # "SysInitPath"=>"/var/lib/docker/init/dockerinit-0.7.2",
        # "ResolvConfPath"=>"/etc/resolv.conf",
        # "HostnamePath"=>"/var/lib/docker/containers/2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650/hostname",
        # "HostsPath"=>"/var/lib/docker/containers/2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650/hosts",
        # "Name"=>"/boring_engelbart",
        # "Driver"=>"devicemapper",
        # "Volumes"=>{},
        # "VolumesRW"=>{},
        # "HostConfig"=>{
        #     "Binds"=>nil,
        #     "ContainerIDFile"=>"",
        #     "LxcConf"=>[],
        #     "Privileged"=>false,
        #     "PortBindings"=>{},
        #     "Links"=>nil,
        #     "PublishAllPorts"=>false}
        # }

        def ready?
          reload if state_running.nil?
          state_running
        end

        def stopped?
          !ready?
        end

        def mac
          # TODO
        end

        def start(options = {})
          service.container_action(:id =>id, :action => :start!)
          reload
        end

        def stop(options = {})
          action = options['force'] ? :kill : :stop
          service.container_action(:id =>id, :action => action)
          reload
        end

        def restart(options = {})
          service.container_action(:id =>id, :action => :restart!)
          reload
        end

        def commit(options = {})
          service.container_commit({:id=>id}.merge(options))
        end

        def destroy(options = {})
          service.container_action(:id =>id, :action => :kill)
          service.container_delete(:id => id)
        end

        def logs(options = { :stdout => 1, :stderr => 1 })
          service.container_action(:id =>id, :action => :logs, :options => options)
        end

        def top(options = {})
          service.container_action(:id =>id, :action => :top)
        end

        def save
          if persisted?
            service.container_update(attributes)
          else
            self.id = service.container_create(attributes)['id']
          end
          reload
        end

        def to_s
          name
        end
      end
    end
  end
end
