Shindo.tests('Fog::Compute[:vsphere] | list_child_snapshots request', ['vsphere']) do

  compute = Fog::Compute[:vsphere]

  tests('The response should') do
    response = compute.list_child_snapshots('snapshot-0101')
    test('be a kind of Array') { response.kind_of? Array }
    test('it should contains Hashes') { response.all? { |i| Hash === i } }
  end
end
