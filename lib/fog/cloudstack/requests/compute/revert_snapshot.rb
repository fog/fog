module Fog
  module Compute
    class Cloudstack

      class Real
        # revert a volume snapshot.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/revertSnapshot.html]
        def revert_snapshot(options={})
          request(options)
        end


        def revert_snapshot(id, options={})
          options.merge!(
            'command' => 'revertSnapshot', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

