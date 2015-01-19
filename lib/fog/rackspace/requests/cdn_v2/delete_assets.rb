class Fog::Rackspace::CDNV2::Real
  def delete_assets(service, options={})
    uri = request_uri("services/#{service.id}/assets", options)

    request(
      :expects => 202,
      :method  => 'DELETE',
      :path    => uri,
      :headers => { :accept => "*/*" }
    )
  end
end
