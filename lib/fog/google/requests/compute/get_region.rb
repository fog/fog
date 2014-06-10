module Fog
  module Compute
    class Google
      class Mock
        def get_region(identity)
          regions = Fog::Compute[:google].list_regions
          region = regions.body['items'].select { |region| region['name'] == identity }

          raise Fog::Errors::NotFound if region.nil? || region.empty?
          build_response(:body => region.first)
        end
      end

      class Real
        def get_region(identity)
          api_method = @compute.regions.get
          parameters = {
            'project' => @project,
            'region' => identity.split('/')[-1],
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
