module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createTags.html]
        def create_tags(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createTags') 
          else
            options.merge!('command' => 'createTags', 
            'tags' => args[0], 
            'resourcetype' => args[1], 
            'resourceids' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

