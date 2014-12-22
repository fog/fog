class Fog::Rackspace::CDNV2::Real
  def update_service(service)
    request(
      :expects => [201, 202],
      :method  => 'PATCH',
      :body    => Fog::JSON.encode(service.operations),
      :path    => "services/#{service.id}"
    )
  end
end
