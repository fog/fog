module Fog
  module DNS
    class Rackspace
      module Callback
        protected

        def wait_for_job(job_id, timeout=Fog.timeout, interval=1)
          retries = 5
          response = nil
          Fog.wait_for(timeout, interval) do
            response = service.callback job_id
            if response.body['status'] == 'COMPLETED'
              true
            elsif response.body['status'] == 'ERROR'
              raise Fog::DNS::Rackspace::CallbackError.new(response)
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
