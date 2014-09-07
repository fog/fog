module Fog
  module Compute
    class Cloudstack

      class Real
        # Copies an iso from one zone to another.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/copyIso.html]
        def copy_iso(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'copyIso') 
          else
            options.merge!('command' => 'copyIso', 
            'destzoneid' => args[0], 
            'id' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

