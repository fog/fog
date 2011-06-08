Shindo.tests('Ninfold::Compute | server requests', ['ninefold']) do

  tests('success') do

    tests("#list_templates()").formats(Ninefold::Compute::Formats::Templates::TEMPLATES) do
      pending if Fog.mocking?
      Ninefold[:compute].list_templates(:templatefilter => 'executable')
    end

  end

  tests('failure') do

    #tests("#deploy_virtual_machine()").raises(Excon::Errors::HTTPStatusError) do
    #  pending if Fog.mocking?
    #  Ninefold[:compute].deploy_virtual_machine
    #end

  end

end
