module Fog
  module Compute
    class Google
      class Mock
        def get_region(identity)
          identity = identity.split('/')[-1]
          regions = Fog::Compute[:google].list_regions
          region = regions.body['items'].select { |region| region['name'] == identity }

          raise Fog::Errors::NotFound if region.nil? || region.empty?
          build_excon_response(region.first)
        end
      end

      class Real
        def get_region(identity)
          api_method = @compute.regions.get
          parameters = {
            'project' => @project,
            'region' => identity.split('/')[-1],
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
