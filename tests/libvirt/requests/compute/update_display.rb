Shindo.tests('Fog::Compute[:libvirt] | update_display request', ['libvirt']) do

  compute = Fog::Compute[:libvirt]

  reconfig_target = 'f74d728a-5b62-7e2f-1f84-239aead298ca'
  display_spec = {:password => 'ssaaa'}

  tests('The response should') do
    response = compute.update_display(:uuid => reconfig_target).merge(display_spec)
    test('should be true').succeeds { response }
  end

end
