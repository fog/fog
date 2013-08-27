module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_request(uri)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :path     => uri
          )
        end
      end
    end
  end
end
