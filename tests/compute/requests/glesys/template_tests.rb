Shindo.tests('Fog::Compute[:glesys] | template requests', ['glesys']) do

  tests('success') do

    tests("#template_list()").formats(Glesys::Compute::Formats::Templates::LIST) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].template_list.body['response']
    end

  end

end
