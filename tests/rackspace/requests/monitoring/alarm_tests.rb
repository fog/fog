Shindo.tests('Fog::Rackspace::Monitoring | alarm_tests', ['rackspace','rackspace_monitoring']) do


  account = Fog::Rackspace::Monitoring.new
  entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
  check_id = account.create_check(entity_id, CHECK_CREATE_OPTIONS).data[:headers]["X-Object-ID"]
  alarm_id = nil
  np = "npTechnicalContactsEmail"
  tests('success') do
    tests('#create new alarm').formats(DATA_FORMAT) do
      alarm_criteria = "if (metric['code'] == '404') { return new AlarmStatus(CRITICAL, 'Page not found');}"
      options = {
        :check_id => check_id,
        :notification_plan_id => np,
        :criteria => alarm_criteria
      }
      response = account.create_alarm(entity_id,options).data
      alarm_id = response[:headers]["X-Object-ID"]
      response
    end
    tests('#update alarm').formats(DATA_FORMAT) do
      options = { :label => "Bar"}
      account.update_alarm(entity_id,alarm_id,options).data
    end
    tests('#list alarms').formats(LIST_HEADERS_FORMAT) do
      account.list_alarms(entity_id).data[:headers]
    end
    tests('#get alarm').formats(LIST_HEADERS_FORMAT) do
      account.get_alarm(entity_id,alarm_id).data[:headers]
    end
    tests('#delete alarm').formats(DELETE_DATA_FORMAT) do
      account.delete_alarm(entity_id,alarm_id).data
    end
  end
  tests('failure') do
    tests('#fail to create new alarm(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.create_alarm(entity_id, {:type => ""})
    end
    tests('#fail to update invalid alarm(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      options = { :testing => "Bar" }
      response = account.update_alarm(-1,-1,options)
    end
    tests('#fail to list alarms').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.list_alarms(-1)
    end
    tests('#fail to get alarm').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.get_alarm(-1,-1)
    end
    tests('#fail to delete alarm(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.delete_alarm(-1,-1)
    end
  end
  account.delete_check(entity_id,check_id) unless Fog.mocking?
  account.delete_entity(entity_id) unless Fog.mocking?
end
