Shindo.tests('Fog::Compute[:Glesys] | template requests', ['glesys']) do

  tests('success') do

    tests("#template_list()").formats(Glesys::Compute::Formats::Templates::LIST) do
      pending if Fog.mocking?
      Fog::Compute[:Glesys].template_list.body['response']
    end

  end

end
