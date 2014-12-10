Shindo.tests('Fog::Rackspace::Monitoring | alarm', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  tests('#alarm=') do
    tests('should assign alarm id if object is a string') do
      alarm = Fog::Rackspace::Monitoring::Alarm.new
      id = "123123"
      alarm.id = "123123"
      returns(Fog::Rackspace::Monitoring::Alarm) { alarm.class }
      returns(id) { alarm.id }
    end
    tests('should set check if object is a check') do
      entity_id = "555"
      entity = Fog::Rackspace::Monitoring::Entity.new(:id => entity_id)
      check_id = "54321"
      check = Fog::Rackspace::Monitoring::Check.new(:id => check_id)
      check.entity = entity
      alarm = Fog::Rackspace::Monitoring::Alarm.new
      alarm.check = check.id

      returns(Fog::Rackspace::Monitoring::Alarm) { alarm.class }
      returns(check_id) { alarm.check.id }
    end
  end

  begin
    @entity = service.entities.create :label => "fog_#{Time.now.to_i.to_s}"
    @check = service.checks.create(CHECK_CREATE_OPTIONS.merge(
                                        :label => "fog_#{Time.now.to_i.to_s}",
                                        :entity => @entity) )
    np = "npTechnicalContactsEmail"
    options = CHECK_CREATE_OPTIONS.merge(
      :disabled => false,
      :label => "fog_#{Time.now.to_i.to_s}",
      :entity => @entity,
      :entity_id => @entity.id,
      :check => @check,
      :check_id => @check.id,
      :notification_plan_id => np
    )
    collection = service.alarms(:entity => @entity)
    model_tests(collection, options, false) do
      tests('#update').succeeds do
        @instance.disabled = true
        new_label = "new_label_#{Time.now.to_i.to_s}"
        @instance.label = new_label
        @instance.save
        @instance.label = nil # blank out label just to make sure
        @instance.reload
        returns(new_label) { @instance.label}
        returns(true) { @instance.disabled }
      end

    end
  ensure
    @entity.destroy if @entity
  end
end
