module Fog
  module Compute
    class VcloudDirector
      class Real


        def get_organizations
          request({
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "org"
          })
        end

      end


    end
  end
end
