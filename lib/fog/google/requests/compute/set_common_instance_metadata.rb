module Fog
  module Compute
    class Google

      class Mock

        def set_common_instance_metadata(metadata={}, project_name=@project)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def set_common_instance_metadata(metadata={}, project_name=@project)
          api_method = @compute.projects.set_common_instance_metadata
          parameters = {
            'project' => project_name
          }
          body_object = {
            "items" => metadata.to_a.map {|pair| { :key => pair[0], :value => pair[1] } }
          }
          result = self.build_result(
            api_method,
            parameters,
            body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
