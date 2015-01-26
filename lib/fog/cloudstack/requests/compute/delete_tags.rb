module Fog
  module Compute
    class Cloudstack

      class Real
        # Deleting resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteTags.html]
        def delete_tags(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteTags') 
          else
            options.merge!('command' => 'deleteTags', 
            'resourceids' => args[0], 
            'resourcetype' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

