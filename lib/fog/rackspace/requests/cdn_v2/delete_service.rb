class Fog::Rackspace::CDNV2::Real
  def delete_service(service)
    request(
      :expects => 202,
      :method  => 'DELETE',
      :path    => "services/#{service.id}"
    )
  end
end
