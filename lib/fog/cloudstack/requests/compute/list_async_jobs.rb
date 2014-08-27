module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all pending asynchronous jobs for the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listAsyncJobs.html]
        def list_async_jobs(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listAsyncJobs') 
          else
            options.merge!('command' => 'listAsyncJobs')
          end
          request(options)
        end
      end
 
      class Mock
        def list_async_jobs(options={})
          # FIXME: support paging
          jobs = self.data[:jobs]
          {
            'listasyncjobsresponse' => {
              'count' => jobs.size,
              'asyncjobs' => jobs
            }
          }
        end
      end 
    end
  end
end

