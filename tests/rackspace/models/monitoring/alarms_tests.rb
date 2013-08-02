Shindo.tests('Fog::Rackspace::Monitoring | alarms', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  begin
    @entity = service.entities.create :label => "fog_#{Time.now.to_i.to_s}"
    @check = service.checks.create(CHECK_CREATE_OPTIONS.merge(
                                        :label => "fog_#{Time.now.to_i.to_s}",
                                        :entity => @entity) )
    np = "npTechnicalContactsEmail"
    options = CHECK_CREATE_OPTIONS.merge(
      :label => "fog_#{Time.now.to_i.to_s}",
      :entity => @entity,
      :entity_id => @entity.id,
      :check => @check,
      :check_id => @check.id,
      :notification_plan_id => np
    )
    collection = service.alarms(:entity => @entity)
    collection_tests(collection, options, false) do
    end
  ensure
    @entity.destroy if @entity
  end
end
