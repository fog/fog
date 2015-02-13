module Fog
  module Compute
    class Fogdocker
      class Real
        def container_get(id)
          raw_container = Docker::Container.get(id, {}, @connection).json
          processed_container = downcase_hash_keys(raw_container)
          processed_container['hostconfig_port_bindings'] = raw_container['HostConfig']['PortBindings']
          processed_container['hostconfig_links']         = raw_container['HostConfig']['Links']
          processed_container['config_exposed_ports']     = raw_container['Config']['ExposedPorts']
          processed_container
        end
      end
      class Mock
        def container_get(id)
          {'id'                         => '2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650',
           'image'                      => 'mattdm/fedora:f19',
           'command'                    => '/bin/bash',
           'created'                    => '1389876158',
           'status'                     => 'Up 45 hours',
           'state_running'              => true,
           'network_settings_ipaddress' => '172.17.0.2',
           'config_memory'              => '1024',
           'config_cpu_sets'            => '0-3',
           'config_cpu_shares'          => '20',
           'config_hostname'            => '21341234',
           'config_attach_stdin'        => true,
           'config_attach_stdout'       => true,
           'config_attach_stderr'       => true,
           'ports'                      => nil,
           'config_tty'                 => true,
           'hostconfig_privileged'      => true,
           'hostconfig_links'           => nil,
           'hostconfig_port_bindings'   => { "29321/tcp" => [{"HostIp"=>"", "HostPort"=>"3001"}],
                                             "39212/tcp" => [{"HostIp"=>"", "HostPort"=>"2030"}]},
           'state_exit_code'            => 0,
           'state_pid'                  => 2932,
           'cpu_shares'                 => 0,
           'volumes'                    => nil,
           'config_exposed_ports'       => { "29321/tcp" => {}, "39212/tcp" => {} },
           'sizerw'                     => 0,
           'sizerootfs'                 => 0,
           'environment_variables'      => ["HOME=/mydir", "SAMPLEENV=samplevalue"],
           'name'                       => '123123123',
           'names'                      =>  ['/boring_engelbert']}
        end
      end
    end
  end
end
