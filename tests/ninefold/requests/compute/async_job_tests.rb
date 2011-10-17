# This will fail until there are jobs in the system.

Shindo.tests('Fog::Compute[:ninefold] | async job requests', ['ninefold']) do

  tests('success') do

    tests("#list_async_jobs()").formats(Ninefold::Compute::Formats::Jobs::JOBS) do
      pending if Fog.mocking?
      jobs = Fog::Compute[:ninefold].list_async_jobs()
      unless jobs[0]
        raise "No async jobs in system yet - create a VM through web UI to create"
      end
      @jobid = jobs[0]['jobid']
      jobs
    end

    tests("#query_async_job_result()").formats(Ninefold::Compute::Formats::Jobs::JOB_QUERY) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].query_async_job_result(:jobid => @jobid)
    end

  end

  tests('failure') do

    #tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
    #  pending if Fog.mocking?
    #  Fog::Compute[:ninefold].deploy_virtual_machine
    #end

  end

end
