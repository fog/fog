Shindo.tests('Fog::Compute::RackspaceV2 | servers', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Compute::RackspaceV2.new
  options = {
    :name => "fog_server_#{Time.now.to_i.to_s}",
    :flavor_id => 2,
    :image_id => '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001'
  }
  collection_tests(service.servers, options, false) do
    @instance.wait_for { ready? }
  end
end
