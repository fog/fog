Shindo.tests('Fog::Compute[:vsphere] | list_vm_snapshots request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  tests('The response should') do
    response = compute.list_vm_snapshots('5032c8a5-9c5e-ba7a-3804-832a03e16381')
    test('be a kind of Array') { response.kind_of? Array }
    test('it should contains Hashes') { response.all? { |i| Hash === i } }
  end
end
