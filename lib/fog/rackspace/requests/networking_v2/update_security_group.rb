class Fog::Rackspace::NetworkingV2::Real
  def update_security_group(security_group)
    data = {:security_group => {:name => security_group.name}}

    request(
      :method  => 'PUT',
      :body    => Fog::JSON.encode(data),
      :path    => "security-groups/#{security_group.id}",
      :expects => 200
    )
  end
end
