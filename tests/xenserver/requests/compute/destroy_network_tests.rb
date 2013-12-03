Shindo.tests('Fog::Compute[:xenserver] | destroy_network request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests('success') do
    test('#destroy_network') do
      @ref = compute.create_network 'test-net'
      compute.destroy_network @ref
      (compute.networks.find { |n| n.reference == @ref }).nil?
    end
  end
  
end
