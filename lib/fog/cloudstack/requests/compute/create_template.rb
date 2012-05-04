module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a new template from a stopped virtual machine instance
        #
        # ==== Parameters
        # * displayText<~String>: The display text of the template. This is usually used for display purposes.
        # * name<~String>: The name of the template.
        # * osTypeId<~Integer>: The ID of the OS Type that best represents the OS of this template.
        # * options<~Hash>: A hash of optional parameters, see the documentation below for details
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createTemplate.html]
        def create_template(displayText, name, osTypeId, options={})
          options.merge!(
            'command'     => 'createTemplate',
            'displaytext' => displayText,
            'name'        => name,
            'ostypeid'    => osTypeId
          )

          request(options)
        end

      end

      class Mock

        def create_template(displayText, name, osTypeId, options={})
          {'createtemplateresponse'=>{'jobid'=>123, 'id'=>123}}
        end

      end
    end
  end
end