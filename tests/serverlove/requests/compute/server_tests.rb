Shindo.tests('Fog::Compute[:serverlove] | server requests', ['serverlove']) do
  
  tests('success') do

    tests("#list_servers").succeeds do
      Fog::Compute[:serverlove].servers
    end

  end

end
