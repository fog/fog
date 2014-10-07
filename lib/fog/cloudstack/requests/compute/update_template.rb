module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates attributes of a template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateTemplate.html]
        def update_template(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateTemplate') 
          else
            options.merge!('command' => 'updateTemplate', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

