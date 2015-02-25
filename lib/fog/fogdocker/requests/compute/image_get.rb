module Fog
  module Compute
    class Fogdocker
      class Real
        def image_get(id)
          downcase_hash_keys Docker::Image.get(id, {}, @connection).json
        end
      end
      class Mock
        def image_get(id)
          {'id'=>'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef3',
           'repotags' => ['repo/other'],
           'created' => 1389877693,
           'size' => 3265536}
        end
      end
    end
  end
end
