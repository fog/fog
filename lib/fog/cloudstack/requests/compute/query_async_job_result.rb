module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves the current status of asynchronous job.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/queryAsyncJobResult.html]
        def query_async_job_result(jobid, options={})
          options.merge!(
            'command' => 'queryAsyncJobResult', 
            'jobid' => jobid  
          )
          request(options)
        end
      end
 
      class Mock
        def query_async_job_result(options={})
          unless job_id = options['jobid']
            raise Fog::Compute::Cloudstack::BadRequest.new("Missing required parameter jobid")
          end

          unless job = self.data[:jobs][job_id]
            raise Fog::Compute::Cloudstack::BadRequest.new("Unknown job id #{job_id}")
          end

          {'queryasyncjobresultresponse' => job }
        end
      end 
    end
  end
end

