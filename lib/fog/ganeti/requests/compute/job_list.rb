module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns a list of all jobs.

        def job_list job_id
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/jobs/#{job_id}"
          )
        end

      end

      class Mock

        def job_list job_id
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
