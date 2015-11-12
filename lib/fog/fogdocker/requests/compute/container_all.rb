module Fog
  module Compute
    class Fogdocker
      class Real
        # filter options
        # all – true or false, Show all containers. Only running containers are shown by default
        # limit – Show limit last created containers, include non-running ones.
        # since – Show only containers created since Id, include non-running ones.
        # before – Show only containers created before Id, include non-running ones.
        # size – true or false, Show the containers sizes
        def container_all(filters = {})
          Docker::Container.all(filters.merge(:all => true), @connection).map do |container|
            downcase_hash_keys(container.json)
          end
        end
      end
      class Mock
        def container_all(filters = {})
          [
              {'id'         => '2ce79789656e4f7474624be6496dc6d988899af30d556574389a19aade2f9650',
               'image'      => 'mattdm/fedora:f19',
               'command'    => '/bin/bash',
               'created'    => '1389876158',
               'status'     => 'Up 45 hours',
               'state_running' => true,
               'ports'      =>  nil,
               'sizerw'     =>  0,
               'sizerootfs' =>  0,
               'name'       => '123123123',
               'names'      =>  ['/boring_engelbert']
              }
          ]
        end
      end
    end
  end
end
