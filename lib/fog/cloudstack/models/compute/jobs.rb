require 'fog/core/collection'
require 'fog/cloudstack/models/compute/job'

module Fog
  module Compute
    class Cloudstack
      class Jobs < Fog::Collection
        model Fog::Compute::Cloudstack::Job

        def all
          data = service.list_async_jobs["listasyncjobsresponse"]["asyncjobs"] || []
          load(data)
        end

        def get(job_id)
          if job = service.query_async_job_result('jobid' => job_id)["queryasyncjobresultresponse"]
            new(job)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end
    end
  end
end
