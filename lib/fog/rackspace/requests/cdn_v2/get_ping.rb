class Fog::Rackspace::CDNV2::Real
  def get_ping
    request(
      :expects => [204],
      :method  => 'GET',
      :path    => "ping",
      :headers => { :accept => "*/*" }
    )
  end
end
