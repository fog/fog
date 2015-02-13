module Fog
  module Compute
    class Fogdocker
      class Real
        def image_create(attrs)
          downcase_hash_keys Docker::Image.create(attrs, nil, @connection).json
        end
      end

      class Mock
        def image_create(attrs)
          {'id'=>'a6b02c7ca29a22619f7d0e59062323247739bc0cd375d619f305f0b519af4ef2'}
        end
      end
    end
  end
end
