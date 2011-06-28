module Fog
  module Storage
    class Ninefold
      class Real

        def delete_namespace(namespace = '', options = {})
          namespace = namespace + '/' unless namespace =~ /\/$/
          options = options.reject {|key, value| value.nil?}
          request(
                  :expects  => 204,
                  :method   => 'DELETE',
                  :path     => "namespace/" + namespace,
                  :query    => options
          )
        end

      end
    end
  end
end
