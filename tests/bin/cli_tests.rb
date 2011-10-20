Shindo.tests('cli_tests', 'cli') do

  Thread.current[:formatador] = Formatador.new # reset indentation

  EMPTY_SERVER_LISTING = Fog::Compute[:aws].servers.all.inspect + "\n"

  empty_server_listing_implicit_arguments = 'aws:compute:servers --mock'
  tests(empty_server_listing_implicit_arguments).returns(EMPTY_SERVER_LISTING) do
    bin(empty_server_listing_implicit_arguments)
  end

  empty_server_listing_explicit_arguments = 'aws:compute:servers:all --mock'
  tests(empty_server_listing_explicit_arguments).returns(EMPTY_SERVER_LISTING) do
    bin(empty_server_listing_explicit_arguments)
  end

end
