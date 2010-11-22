module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Waits for changes on a job.
        #
        # Body parameters:
        #   - http://docs.ganeti.org/ganeti/2.2/html/rapi.html#jobs-job-id-wait

        def job_wait job_id, opts = {}
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/jobs/#{job_id}/wait",
            :body    => opts.to_json
          )
        end

      end

      class Mock

        def job_wait job_id, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
