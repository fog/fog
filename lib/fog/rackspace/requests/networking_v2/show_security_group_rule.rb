class Fog::Rackspace::NetworkingV2::Real
  def show_security_group_rule(id)
    request(:method => 'GET', :path => "security-group-rules/#{id}", :expects => 200)
  end
end
