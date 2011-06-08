Shindo.tests('Ninefold::Compute | server requests', ['ninefold']) do

  tests('success') do


    tests("#associate_ip_address()").formats(Ninefold::Compute::Formats::Addresses::ADDRESS) do
      pending if Fog.mocking?
      job = newaddress = Ninefold[:compute].associate_ip_address(:zoneid => Ninefold::Compute::TestSupport::ZONE_ID)
      while Ninefold[:compute].query_async_job_result(:jobid => job['jobid'])['jobstatus'] == 0
        sleep 1
      end
      result = Ninefold[:compute].query_async_job_result(:jobid => job['jobid'])['jobresult']['ipaddress']
      @newaddressid = result['id']
      Ninefold::Compute::Formats::Addresses::fill_address_data(result)
    end

    tests("#list_public_ip_addresses()").formats(Ninefold::Compute::Formats::Addresses::ADDRESSES) do
      pending if Fog.mocking?
      result = Ninefold[:compute].list_public_ip_addresses
      Ninefold::Compute::Formats::Addresses::fill_address_data(result)
    end

    tests("#disassociate_ip_address()").formats(Ninefold::Compute::Formats::Addresses::DISASSOC_ADDRESS) do
      pending if Fog.mocking?
      job = Ninefold[:compute].disassociate_ip_address(:id => @newaddressid)
      while Ninefold[:compute].query_async_job_result(:jobid => job['jobid'])['jobstatus'] == 0
        sleep 1
      end
      job
    end

  end

  tests('failure') do

    tests("#associate_ip_address()").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Ninefold[:compute].associate_ip_address
    end

  end

end
