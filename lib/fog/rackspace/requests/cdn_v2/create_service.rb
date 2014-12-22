class Fog::Rackspace::CDNV2::Real
  def create_service(service)
    request(
      :expects => [201, 202],
      :method  => 'POST',
      :body    => Fog::JSON.encode(service),
      :path    => "services"
    )
  end
end
