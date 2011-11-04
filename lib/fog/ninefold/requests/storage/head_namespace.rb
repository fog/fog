module Fog
  module Storage
    class Ninefold
      class Real

        def head_namespace(namespace = '', options = {})
          options = options.reject {|key, value| value.nil?}
          request({
                    :expects  => 200,
                    :method   => 'HEAD',
                    :path     => "namespace/" + namespace,
                    :query    => {},
                    :parse => true
                  }.merge(options))
        end

      end
    end
  end
end
