module Fog
  module Compute
    class Cloudstack
      class Real

        def list_async_jobs(options={})
          options.merge!(
            'command' => 'listAsyncJobs'
          )
          
          request(options)
        end

      end
    end
  end
end
