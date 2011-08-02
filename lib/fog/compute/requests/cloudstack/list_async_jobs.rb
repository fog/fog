module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all pending asynchronous jobs for the account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listAsyncJobs.html]
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
