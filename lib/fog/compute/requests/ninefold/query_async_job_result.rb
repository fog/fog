module Fog
  module Ninefold
    class Compute
      class Real

        def query_async_job_result(options = {})
          request('queryAsyncJobResult', options, :expects => [200],
                  :response_prefix => 'queryasyncjobresultresponse', :response_type => Array)
        end

      end

      class Mock

        def query_async_job_result(*args)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
