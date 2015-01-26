class Fog::Rackspace::CDNV2::Real
  def get_home_document
    request(
      :expects => [200],
      :method  => 'GET',
      :path    => ""
    )
  end
end
