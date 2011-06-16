module Fog
  module Compute
    class Ninefold
      class Real

        def list_async_jobs(options = {})
          puts "about to perf request.."
          request('listAsyncJobs', options, :expects => [200],
                  :response_prefix => 'listasyncjobsresponse/asyncjobs', :response_type => Array)
        end

      end
    end
  end
end
