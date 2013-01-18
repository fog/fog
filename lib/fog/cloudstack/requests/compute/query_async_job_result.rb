module Fog
  module Compute
    class Cloudstack
      class Real

        def query_async_job_result(options={})
          options.merge!(
            'command' => 'queryAsyncJobResult'
          )

          request(options)
        end

      end # Real

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
