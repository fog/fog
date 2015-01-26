class Fog::Rackspace::CDNV2::Real
  def list_flavors
    request(
      :expects => [200],
      :method  => 'GET',
      :path    => "flavors"
    )
  end
end
