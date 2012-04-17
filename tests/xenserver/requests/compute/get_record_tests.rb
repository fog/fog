Shindo.tests('Fog::Compute[:xenserver] | get_record request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  vm_ref = 'alksjdfoiuoiwueroiwe'

  tests('The response should') do
    raises(Fog::XenServer::RequestFailed, 'when ref invalid') do
      response = compute.get_record(vm_ref, 'VM')
    end
  end
  
  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,class missing') { compute.get_record }
  end
end
