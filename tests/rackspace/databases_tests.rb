Shindo.tests('Fog::Rackspace::Databases', ['rackspace']) do |variable|

  pending if Fog.mocking?

  @service = Fog::Rackspace::Databases.new

  tests('#flavors').succeeds do
    data = @service.flavors
    returns(true) { data.is_a? Array }
  end

  tests('#instances').succeeds do
    data = @service.instances
    returns(true) { data.is_a? Array }
  end

  tests('#databases').succeeds do
    data = @service.databases
    returns(true) { data.is_a? Array }
  end

  tests('#users').succeeds do
    data = @service.users
    returns(true) { data.is_a? Array }
  end
end
