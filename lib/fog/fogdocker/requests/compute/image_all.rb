module Fog
  module Compute
    class Fogdocker
      class Real
        def image_all(filters = {})
          Docker::Image.all({}, @connection).map do |image|
            downcase_hash_keys(image.json)
          end
        end
      end
      class Mock
        def image_all(filters = {})
          [
            {'id'=>'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef2',
             'repotags' => ['repo/one'],
             'created' => 1389877693,
             'size' => 3265536},
            {'id'=>'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef3',
             'repotags' => ['repo/other'],
             'created' => 1389877693,
             'size' => 3265536}
          ]
        end
      end
    end
  end
end
