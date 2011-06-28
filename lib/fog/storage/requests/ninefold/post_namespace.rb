module Fog
  module Storage
    class Ninefold
      class Real

        def post_namespace(namespace = '', options = {})
          namespace = namespace + '/' unless namespace =~ /\/$/
          options = options.reject {|key, value| value.nil?}
          request(
                  :expects  => 201,
                  :method   => 'POST',
                  :path     => "namespace/" + namespace,
                  :query    => options,
                  :parse => true
          )
        end

      end
    end
  end
end
