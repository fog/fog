Shindo.tests('Fog::Compute[:ninefold] | address requests', ['ninefold']) do

  tests('success') do

    tests("#associate_ip_address()").formats(Ninefold::Compute::Formats::Addresses::ADDRESS) do
      pending if Fog.mocking?
      job = newaddress = Fog::Compute[:ninefold].associate_ip_address(:zoneid => Ninefold::Compute::TestSupport::ZONE_ID)
      while Fog::Compute[:ninefold].query_async_job_result(:jobid => job['jobid'])['jobstatus'] == 0
        sleep 1
      end
      result = Fog::Compute[:ninefold].query_async_job_result(:jobid => job['jobid'])['jobresult']['ipaddress']
      @newaddressid = result['id']
      result
    end

    tests("#list_public_ip_addresses()").formats(Ninefold::Compute::Formats::Addresses::ADDRESSES) do
      pending if Fog.mocking?
      result = Fog::Compute[:ninefold].list_public_ip_addresses
      result
    end

    tests("#disassociate_ip_address()").formats(Ninefold::Compute::Formats::Addresses::DISASSOC_ADDRESS) do
      pending if Fog.mocking?
      job = Fog::Compute[:ninefold].disassociate_ip_address(:id => @newaddressid)
      while Fog::Compute[:ninefold].query_async_job_result(:jobid => job['jobid'])['jobstatus'] == 0
        sleep 1
      end
      job
    end

  end

  tests('failure') do

    tests("#associate_ip_address()").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].associate_ip_address
    end

  end

end
