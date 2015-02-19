module Fog
  module Compute
    class Fogdocker
      class Real
        def container_commit(options)
          raise ArgumentError, "instance id is a required parameter" unless options.key? :id
          container = Docker::Container.get(options[:id], {}, @connection)
          downcase_hash_keys container.commit(camelize_hash_keys(options)).json
        end
      end

      class Mock
        def container_commit(options)
          {'id'=>'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef3',
           'repotags' => ['repo/other'],
           'created' => 1389877693,
           'size' => 3265536}
        end
      end
    end
  end
end
