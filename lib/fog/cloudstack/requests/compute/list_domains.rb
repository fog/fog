module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists domains and provides detailed information for listed domains
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDomains.html]
        def list_domains(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDomains') 
          else
            options.merge!('command' => 'listDomains')
          end
          request(options)
        end
      end

    end
  end
end

