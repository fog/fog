def test
  client = Google::APIClient.new({ :application_name => "supress", })
  connection = Fog::Compute.new({
    :provider => "Google",
    :google_client => client,
  })

  begin
    p connection.client.discovered_apis
    p connection.servers
  rescue Exception => e
    p e.message
  end
end
