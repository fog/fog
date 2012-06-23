Shindo.tests('Fog::Rackspace::Database | instance_tests', ['rackspace']) do

  pending if Fog.mocking?

  @service = Fog::Rackspace::Databases.new

  tests('success') do
    tests("#list_flavors_details").formats(DATABASE_FLAVORS_FORMAT) do
      @service.list_flavors_details.body
    end
  end
end
