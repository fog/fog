module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a template from the system. All virtual machines using the deleted template will not be affected.
        #
        # ==== Parameters
        # * id<~Integer>: The ID of the template
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteTemplate.html]
        def delete_template(id, options={})
          options.merge!(
            'command' => 'deleteTemplate',
            'id'      => id
          )

          request(options)
        end
      end

      class Mock
        def delete_template(id, options={})
          {
            "deletetemplateresponse" => {
              "jobid"       =>155,
              "success"     => true,
              "displaytext" => "success"
            }
          }
        end
      end
    end
  end
end