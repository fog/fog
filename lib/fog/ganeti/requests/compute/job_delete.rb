module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Cancel a not-yet-started job.

        def job_delete job_id
          request(
            :expects => 200,
            :method  => 'DELETE',
            :path    => "/2/jobs/#{job_id}/delete"
          )
        end

      end

      class Mock

        def job_delete job_id
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
