module Fog
  module Storage
    class Atmos
      class Real
<<<<<<< HEAD

        def get_namespace(namespace = '', options = {}, &block)
>>>>>>> upstream/master
          options = options.reject {|key, value| value.nil?}

          if block_given?
            options[:response_block] = Proc.new
          end

          request({
                    :expects  => 200,
                    :method   => 'GET',
                    :path     => "namespace/" + URI.escape(namespace),
                    :query    => {},
                    :parse => true
                  }.merge(options))
        end
      end
    end
  end
end
