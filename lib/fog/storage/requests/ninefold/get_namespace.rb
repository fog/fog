module Fog
  module Storage
    class Ninefold
      class Real

        def get_namespace(namespace = '', options = {})
          namespace = namespace + '/' unless namespace =~ /\/$/
          options = options.reject {|key, value| value.nil?}
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "namespace/" + namespace,
                  :query    => options,
                  :parse => true
          )
        end

      end
    end
  end
end
