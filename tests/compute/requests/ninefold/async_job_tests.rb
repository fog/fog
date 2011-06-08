# This will fail until there are jobs in the system.

Shindo.tests('Ninfold::Compute | server requests', ['ninefold']) do

  tests('success') do

    tests("#list_async_jobs()").formats(Ninefold::Compute::Formats::Jobs::JOBS) do
      pending if Fog.mocking?
      jobs = Ninefold[:compute].list_async_jobs()
      unless jobs[0]
        raise "No async jobs in system yet - create a VM through web UI to create"
      end
      @jobid = jobs[0]['jobid']
      jobs
    end

    tests("#query_async_job_result()").formats(Ninefold::Compute::Formats::Jobs::JOB_QUERY) do
      pending if Fog.mocking?
      Ninefold[:compute].query_async_job_result(:jobid => @jobid)
    end

  end

  tests('failure') do

    #tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
    #  pending if Fog.mocking?
    #  Ninefold[:compute].deploy_virtual_machine
    #end

  end

end
