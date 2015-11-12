class Fog::Rackspace::NetworkingV2::Real
  def create_security_group(security_group)
    data = {:security_group => security_group.attributes}

    request(
      :method  => 'POST',
      :body    => Fog::JSON.encode(data),
      :path    => "security-groups",
      :expects => 201
    )
  end
end
