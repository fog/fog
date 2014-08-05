module Fog
  module Compute
    class Fogdocker
      class Real
        def container_get(id)
          downcase_hash_keys Docker::Container.get(id).json
        end
      end
      class Mock
        def container_get(id)
          {'id'         => '2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650',
           'image'      => 'mattdm/fedora:f19',
           'command'    => '/bin/bash',
           'created'    => '1389876158',
           'status'     => 'Up 45 hours',
           'state_running'              => true,
           'config_cpu_shares'          => '1',
           'network_settings_ipaddress' => '172.17.0.2',
           'config_memory'              => '1024',
           'config_hostname'            => '21341234',
           'ports'      =>  nil,
           'sizerw'     =>  0,
           'sizerootfs' =>  0,
           'name'       => '123123123',
           'names'      =>  ['/boring_engelbert']}
        end
      end
    end
  end
end
