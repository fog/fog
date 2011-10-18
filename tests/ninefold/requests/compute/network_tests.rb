Shindo.tests('Fog::Compute[:ninefold] | network requests', ['ninefold']) do

  tests('success') do

    tests("#list_networks()").formats(Ninefold::Compute::Formats::Networks::NETWORKS) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_networks()
    end

  end

  tests('failure') do

    #tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
    #  pending if Fog.mocking?
    #  Fog::Compute[:ninefold].deploy_virtual_machine
    #end

  end

end
