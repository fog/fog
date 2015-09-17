## TODO re-enable when server creates work again

# Shindo.tests('Fog::Compute::DigitalOceanV2 | get_server request', ['digitalocean', 'compute']) do
#   service = Fog::Compute.new(:provider => 'DigitalOcean', :version => 'V2')
#
#   tests('success') do
#     test('#get_server_details') do
#       server = fog_test_server
#       body   = service.get_server(server.id).body
#       body['droplet']['name'] == fog_server_name
#     end
#   end
# end