module Fog
  module Compute
    class Fogdocker
      # Create attributes
      #'Hostname' => '',
      #'User' => '',
      #'Memory' => 0,
      #'MemorySwap' => 0,
      #'AttachStdin' => false,
      #'AttachStdout' => true,
      #'AttachStderr' => true,
      #'PortSpecs' => nil,
      #'Tty' => false,
      #'OpenStdin' => false,
      #'StdinOnce' => false,
      #'Env' => nil,
      #'Cmd' => ['date'],
      #'Dns' => nil,
      #'Image' => 'base',
      #'Volumes' => {
      #    '/tmp' =>  {}
      #},
      #'VolumesFrom' => '',
      #'WorkingDir' => '',
      #'ExposedPorts' => {
      #    '22/tcp' => {}
      #}
      class Real
        def container_create(attrs)
          downcase_hash_keys Docker::Container.create(camelize_hash_keys(attrs), @connection).json
        end
      end

      class Mock
        def container_create(attrs)
          {'id'         => '2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650',
           'image'      => 'mattdm/fedora:f19',
           'command'    => '/bin/bash',
           'created'    => '1389876158',
           'status'     => 'Up 45 hours',
           'state'      => {'running' => 'true'},
           'ports'      =>  nil,
           'sizerw'     =>  0,
           'sizerootfs' =>  0,
           'name'       => '123123123',
           'names'      =>  ['/boring_engelbert']
          }
        end
      end
    end
  end
end
