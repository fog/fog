Shindo.tests('Fog::Compute[:brightbox] | collaboration requests', ['brightbox']) do

  tests('success') do

    tests("#create_collaboration") do
      pending if Fog.mocking?
      collaboration = Fog::Compute[:brightbox].create_collaboration(:email => "paul@example.com", :role => "admin")
      @collaboration_id = collaboration['id']
      formats(Brightbox::Compute::Formats::Full::COLLABORATION, false) { collaboration }
    end


    tests("#list_collaborations") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_collaborations

      formats(Brightbox::Compute::Formats::Collection::COLLABORATIONS, false) { result }
    end

    tests("#get_collaboration") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_collaboration(@collaboration_id)
      formats(Brightbox::Compute::Formats::Full::COLLABORATION, false) { result }
    end


    tests("#destroy_collaboration") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_collaboration(@collaboration_id)
      formats(Brightbox::Compute::Formats::Full::COLLABORATION, false) { result }
    end
  end

  tests("failure") do
    tests("get_collaboration('col-abcde')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_collaboration("col-abcde")
    end
  end

end
