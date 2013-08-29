module Fog
  module Compute
    class VcloudDirector
      class Real


        def get_organizations
          request({
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "org"
          })
        end

      end


    end
  end
end
