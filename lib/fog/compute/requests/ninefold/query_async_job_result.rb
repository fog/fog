module Fog
  module Ninefold
    class Compute
      class Real

        def query_async_job_result(options = {})
          request('queryAsyncJobResult', options, :expects => [200],
                  :response_prefix => 'queryasyncjobresultresponse', :response_type => Array)
        end

      end
    end
  end
end
