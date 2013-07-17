Shindo.tests('Fog::Rackspace::Monitoring | check_alarms', ['rackspace','rackspacemonitoring']) do
  pending if Fog.mocking? 

  account = Fog::Rackspace::Monitoring.new
  entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
  check_id = account.create_check(entity_id, CHECK_CREATE_OPTIONS).data[:headers]["X-Object-ID"]
  alarm_id = nil
  ##############################################################################
  # Notification plan was created externally with raxmon.  Should create one on
  # the fly once there is support for notifications plans in fog
  ##############################################################################
  np = "npKV0PI5Js"
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
    # delete is not currently supported in fog
    #tests('#delete alarm').formats(DELETE_DATA_FORMAT) do
      #account.delete_alarm(entity_id,check_id).data
    #end
  end
  tests('failure') do
    tests('#create new alarm(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.create_alarm(entity_id, {:type => ""})
    end
    # Commenting out update because incorrect update throws a 502
    #tests('#update invalid alarm(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      #options = { :testing => "Bar" }
      #response = account.update_alarm(-1,-1,options)
    #end
    # delete is not currently supported in fog
    #tests('#delete alarm(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      #account.delete_alarm(-1,-1)
    #end
  end
  account.delete_check(entity_id,check_id)
  account.delete_entity(entity_id)
end
