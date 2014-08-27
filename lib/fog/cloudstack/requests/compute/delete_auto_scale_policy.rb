module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a autoscale policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteAutoScalePolicy.html]
        def delete_auto_scale_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteAutoScalePolicy') 
          else
            options.merge!('command' => 'deleteAutoScalePolicy', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

