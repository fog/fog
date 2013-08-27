module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def get_href(href)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :override_path => true,
            :path     => URI.parse(href).path
          )
        end

      end
    end
  end
end
