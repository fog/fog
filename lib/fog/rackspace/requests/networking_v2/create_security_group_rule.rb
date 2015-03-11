class Fog::Rackspace::NetworkingV2::Real
  def create_security_group_rule(security_group_rule)
    data = {:security_group_rule => security_group_rule.attributes}

    request(
      :method  => 'POST',
      :body    => Fog::JSON.encode(data),
      :path    => "security-group-rules",
      :expects => 201
    )
  end
end
