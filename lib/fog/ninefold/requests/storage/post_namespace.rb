module Fog
  module Storage
    class Ninefold
      class Real

        def post_namespace(namespace = '', options = {})
          options = options.reject {|key, value| value.nil?}
          request({
                    :expects  => 201,
                    :method   => 'POST',
                    :path     => "namespace/" + namespace,
                    :query    => {},
                    :parse => true
                  }.merge(options))
        end

      end
    end
  end
end
