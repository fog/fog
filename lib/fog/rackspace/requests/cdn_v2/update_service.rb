class Fog::Rackspace::CDNV2::Real
  def update_service(service)
    request(
      :expects => [201, 202],
      :method  => 'PATCH',
      :headers => {"Content-Type" => "application/json-patch+json"},
      :body    => Fog::JSON.encode(service.operations),
      :path    => "services/#{service.id}"
    )

    service.operations = []
  end
end
