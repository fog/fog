Shindo.tests('Fog::Rackspace::Monitoring | checks', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  begin
    @entity = service.entities.create :label => "fog_#{Time.now.to_i.to_s}"

    options = CHECK_CREATE_OPTIONS.merge(:label => "fog_#{Time.now.to_i.to_s}", :entity => @entity)
    collection = service.checks(:entity => @entity)
    collection_tests(collection, options, false) do

    end
  ensure
    @entity.destroy if @entity
  end
end
