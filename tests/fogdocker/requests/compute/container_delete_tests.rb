Shindo.tests('Fog::Compute[:fogdocker] | container_delete request', ['fogdocker']) do

  compute = Fog::Compute[:fogdocker]
  container = compute.servers.create({'Image' => 'mattdm/fedora:f19',
                                     'Cmd'   => ['/bin/bash']})

  tests('The response should') do
    response = compute.container_delete(:id => container.id)
    test('be a success') { response ? true: false }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when id option is missing') { compute.container_delete }
  end

end
