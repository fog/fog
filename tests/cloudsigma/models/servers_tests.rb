Shindo.tests('Fog::Compute[:cloudsigma] | servers collection', ['cloudsigma']) do
  # mark as pending, the collection_tests are not quite what in line with how CloudSigma servers operate
  pending
  servers = Fog::Compute[:cloudsigma].servers
  server_create_args =  {:name => 'fogtest', :cpu => 2000, :mem => 512*1024**2, :vnc_password => 'myrandompass'}

  collection_tests(servers, server_create_args, true)

end
