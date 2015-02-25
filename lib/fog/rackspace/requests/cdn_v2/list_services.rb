class Fog::Rackspace::CDNV2::Real
  def list_services(options={})
    request(
      :expects => [200],
      :method  => 'GET',
      :path    => request_uri("services", options)
    )
  end
end
