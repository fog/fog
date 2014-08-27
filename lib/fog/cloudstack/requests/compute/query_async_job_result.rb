module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves the current status of asynchronous job.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/queryAsyncJobResult.html]
        def query_async_job_result(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'queryAsyncJobResult') 
          else
            options.merge!('command' => 'queryAsyncJobResult', 
            'jobid' => args[0])
          end
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

