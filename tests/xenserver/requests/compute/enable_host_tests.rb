Shindo.tests('Fog::Compute[:xenserver] | enable_host request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  host = compute.hosts.first
  
  tests('#enable_host') do
    test('enables the host') do
      compute.enable_host host.reference
      host.reload
      host.enabled
    end
  end

  # Cleanup 
  host.enable
end
