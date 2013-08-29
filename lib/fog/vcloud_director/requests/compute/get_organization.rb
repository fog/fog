module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_organization(organization_id)
        
          request({
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "org/#{organization_id}"
          })
        end

      end


    end
  end
end
