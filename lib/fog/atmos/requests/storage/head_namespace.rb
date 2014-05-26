module Fog
  module Storage
    class Atmos
      class Real
        def head_namespace(namespace = '', options = {})
          options = options.reject {|key, value| value.nil?}
          request({
                    :expects  => 200,
                    :method   => 'HEAD',
                    :path     => "namespace/" + URI.escape(namespace),
                    :query    => {},
                    :parse => true
                  }.merge(options))
        end
      end
    end
  end
end
