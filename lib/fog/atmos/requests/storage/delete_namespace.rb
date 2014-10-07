module Fog
  module Storage
    class Atmos
      class Real
        def delete_namespace(namespace = '', options = {})
          options = options.reject {|key, value| value.nil?}
          request({
                    :expects  => 204,
                    :method   => 'DELETE',
                    :path     => "namespace/" + namespace,
                    :query    => options
                  }.merge(options))
        end
      end
    end
  end
end
