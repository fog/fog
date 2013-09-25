Shindo.tests('Fog::Compute[:xenserver] | create_network request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests('success') do
    test('#create_network') do
      @ref = compute.create_network 'test-net'
      !(compute.networks.find { |n| n.reference == @ref }).nil?
    end
    test('#create_network with description') do
      # Destroy previously created network
      compute.networks.get(@ref).destroy
      @ref = compute.create_network 'test-net', :description => 'foo'
      !(compute.networks.find { |n| n.description == 'foo' }).nil?
    end
  end

  compute.destroy_network @ref
  
end
