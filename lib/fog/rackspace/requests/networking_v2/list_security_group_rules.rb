class Fog::Rackspace::NetworkingV2::Real
  def list_security_group_rules
    request(:method => 'GET', :path => 'security-group-rules', :expects => 200)
  end
end
