Shindo.tests('Fog::Compute[:xenserver] | Pools collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]
  
  tests('The pools collection') do
    pools = conn.pools.all

    test('should not be empty') { !pools.empty? }

    test('should be a kind of Fog::Compute::XenServer::Pools') { pools.kind_of? Fog::Compute::XenServer::Pools }

    tests('should be an array of Fog::Compute::XenServer::Pool') do
      pools.each do |p| 
        test("#{p.uuid} is a Fog::Compute::XenServer::Pool") {
          p.is_a? Fog::Compute::XenServer::Pool 
        }
      end
    end

    tests('should be able to reload itself').succeeds { pools.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds { 
        pools.get(pools.first.reference).is_a? Fog::Compute::XenServer::Pool
      }
    end

  end

end
