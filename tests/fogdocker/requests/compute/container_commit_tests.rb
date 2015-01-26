Shindo.tests("Fog::Compute[:fogdocker] | container_create request", 'fogdocker') do

  compute = Fog::Compute[:fogdocker]
  name_base = Time.now.to_i
  hash = compute.container_create(:name => 'fog-'+name_base.to_s, 'image' => 'mattdm/fedora:f19','Cmd' => ['date'] )
  response = {}

  tests("Commit Container") do
    response = compute.container_commit(:id=>hash['id'])
    test("should have Image id") { response.include?  'id'}
  end

  test("Delete Commited Image") do
    result = compute.image_delete(:id=>response['id'])
    test("should have a deleted message") {result.include?('Deleted')}
  end

end
