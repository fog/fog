Shindo.tests('Ninfold::Compute | network requests', ['ninefold']) do

  tests('success') do

    tests("#list_networks()").formats(Ninefold::Compute::Formats::Networks::NETWORKS) do
      pending if Fog.mocking?
      Ninefold[:compute].list_networks()
    end

  end

  tests('failure') do

    #tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
    #  pending if Fog.mocking?
    #  Ninefold[:compute].deploy_virtual_machine
    #end

  end

end
