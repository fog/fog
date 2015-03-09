class Fog::Rackspace::NetworkingV2::Real
  def delete_security_group(id)
    request(:method => 'DELETE', :path => "security-groups/#{id}", :expects => 204)
  end
end
