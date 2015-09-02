class Fog::Rackspace::NetworkingV2::Real
  def delete_security_group_rule(id)
    request(:method => 'DELETE', :path => "security-group-rules/#{id}", :expects => 204)
  end
end
