Shindo.tests('Fog::Compute[:xenserver] | disable_host request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  host = compute.hosts.first
  
  tests('#disable_host') do
    test('disables the host') do
      compute.disable_host host.reference
      host.reload
      !host.enabled
    end
  end

  # Cleanup 
  host.enable
end
