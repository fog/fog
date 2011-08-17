module Fog
  module DNS
    class Rackspace
      class Real
        def list_domains(options={})

          path = 'domains'
          if !options.empty?
            path = path + '?' + options.collect {|k,v| "#{k}=#{v}" }.join('&')
          end

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path
          )
        end
      end
    end
  end
end
