class Fog::Rackspace::NetworkingV2::Real
  def show_security_group(id)
    request(:method => 'GET', :path => "security-groups/#{id}", :expects => 200)
  end
end
