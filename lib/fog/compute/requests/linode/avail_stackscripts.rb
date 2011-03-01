module Fog
  module Linode
    class Compute
      class Real
        def avail_stackscripts(options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.stackscripts' }.merge!(options)
          )
        end
      end
    end
  end
end
