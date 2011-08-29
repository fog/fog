module Fog
  module DNS
    class Rackspace

      module Callback

        protected

        def wait_for_job(job_id, timeout=Fog.timeout, interval=1)
          retries = 5
          response = nil
          Fog.wait_for(timeout, interval) do
            response = connection.callback job_id
            if response.status != 202
              true
            elsif retries == 0
              raise Fog::Errors::Error.new("Wait on job #{job_id} took too long")
            else
              retries -= 1
              false
            end
          end
          response
        end
      end
    end
  end
end
