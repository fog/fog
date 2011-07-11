module Fog
  module Storage
    class Ninefold
      class Real

        def put_namespace(namespace = '', options = {})
          options = options.reject {|key, value| value.nil?}
          request({
                    :expects  => 200,
                    :method   => 'PUT',
                    :path     => "namespace/" + namespace,
                    :query    => {},
                    :parse => true
                  }.merge(options))
        end

      end
    end
  end
end
