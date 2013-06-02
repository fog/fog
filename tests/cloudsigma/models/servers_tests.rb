Shindo.tests('Fog::Compute[:cloudsigma] | servers collection', ['cloudsigma']) do
  servers = Fog::Compute[:cloudsigma].servers
  server_create_args =  {:name => 'fogtest', :cpu => 2000, :mem => 512*1024**2, :vnc_password => 'myrandompass'}

  collection_tests(servers, server_create_args, true)

end