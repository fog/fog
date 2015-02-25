class Fog::Rackspace::CDNV2::Real
  def get_flavor(id)
    request(
      :expects => [200],
      :method  => 'GET',
      :path    => "flavors/#{id}"
    )
  end
end
