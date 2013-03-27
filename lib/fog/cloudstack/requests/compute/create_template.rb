module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a template of a virtual machine. The virtual machine must be in a STOPPED state.
        # A template created from this command is automatically designated as a private template visible to the account that created it.
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createTemplate.html]
        def create_template(options={})
          options.merge!(
              'command' => 'createTemplate'
          )

          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end #Fog
