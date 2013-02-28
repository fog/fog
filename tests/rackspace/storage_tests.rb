Shindo.tests('Fog::Storage::Rackspace', ['rackspace']) do |variable|

  pending if Fog.mocking?
  
  tests('account').succeeds do
     Fog::Storage[:rackspace].account
  end
end