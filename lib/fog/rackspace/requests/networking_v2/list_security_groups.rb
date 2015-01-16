class Fog::Rackspace::NetworkingV2::Real
  def list_security_groups
    request(:method => 'GET', :path => 'security-groups', :expects => 200)
  end
end
