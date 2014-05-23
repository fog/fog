module Fog
  module Compute
    class Cloudstack

      class Real
        # Modify pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/modifyPool.html]
        def modify_pool(options={})
          options.merge!(
            'command' => 'modifyPool',
            'poolname' => options['poolname'], 
            'algorithm' => options['algorithm'], 
             
          )
          request(options)
        end
      end

    end
  end
end

