module Fog
  module Compute
    class Cloudstack

      class Real
        # load template into primary storage
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/prepareTemplate.html]
        def prepare_template(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'prepareTemplate') 
          else
            options.merge!('command' => 'prepareTemplate', 
            'templateid' => args[0], 
            'zoneid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

