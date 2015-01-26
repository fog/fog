class Fog::Rackspace::CDNV2::Real
  def get_service(id)
    request(
      :expects => 200,
      :method  => 'GET',
      :path    => "services/#{id}"
    )
  end
end
