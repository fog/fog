Shindo.tests('Ninfold::Compute | server requests', ['ninefold']) do

  tests('success') do

  end

  tests('failure') do

    tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Ninefold[:compute].deploy_virtual_machine
    end

  end

end
