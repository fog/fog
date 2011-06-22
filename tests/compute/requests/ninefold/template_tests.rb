Shindo.tests('Fog::Compute[:ninefold] | template requests', ['ninefold']) do

  tests('success') do

    tests("#list_templates()").formats(Ninefold::Compute::Formats::Templates::TEMPLATES) do
      pending if Fog.mocking?
      Fog::Compute[:ninefold].list_templates(:templatefilter => 'executable')
    end

  end

  tests('failure') do

    #tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
    #  pending if Fog.mocking?
    #  Fog::Compute[:ninefold].deploy_virtual_machine
    #end

  end

end
