Shindo.tests('Fog::Compute[:xenserver] | get_record request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  vm_ref = '50137835-88a1-436e-768e-9b2677076e67'

  tests('The response should') do
    response = compute.get_record(vm_ref, 'VM')
    test('be nil when ref invalid') { response == nil }
  end
  
  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,class missing') { compute.get_record }
  end
end
