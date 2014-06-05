Shindo.tests('Fog::Rackspace::Monitoring | list_tests', ['rackspace','rackspace_monitoring']) do

  account = Fog::Rackspace::Monitoring.new
  if Fog.mocking?
    entity_id = "peoigne93"
    check_id = "2090wgn93"
  else
    entity_id = account.create_entity(:label => "Foo").data[:headers]["X-Object-ID"]
    check_id = account.create_check(entity_id,CHECK_CREATE_OPTIONS).data[:headers]["X-Object-ID"]
  end

  metric_name = "idle_percent_average"
  now = Time.now.to_i
  SLEEP_TIME= 2
  sleep(SLEEP_TIME) unless Fog.mocking?

  tests('success') do

    tests('#get list of monitoring zones').formats(LIST_MONITORING_ZONE) do
      pending if Fog.mocking?
      account.list_monitoring_zones.body
    end

    tests('#get a monitoring zone').formats(GET_MONITORING_ZONE) do
      pending if Fog.mocking?
      account.get_monitoring_zone('mzdfw').body
    end

    tests('#get list of checks').formats(LIST_HEADERS_FORMAT) do
      account.list_checks(entity_id).data[:headers]
    end
    tests('#get list of check types').formats(LIST_HEADERS_FORMAT) do
      account.list_check_types().data[:headers]
    end
    tests('#get list of entities').formats(LIST_HEADERS_FORMAT) do
      account.list_entities().data[:headers]
    end
    tests('#get list of metrics').formats(LIST_HEADERS_FORMAT) do
     account.list_metrics(entity_id,check_id).data[:headers]
    end
    tests('#get overview list').formats(LIST_HEADERS_FORMAT) do
      account.list_overview().data[:headers]
    end
    tests('#list notification plans').formats(LIST_HEADERS_FORMAT) do
      account.list_notification_plans().data[:headers]
    end
    tests('#list notifications').formats(LIST_HEADERS_FORMAT) do
      account.list_notifications().data[:headers]
    end
    tests('#get list of data points').formats(LIST_HEADERS_FORMAT) do
      options = {
        :points => 1,
        :from => now * 1000,
        :to => (now+SLEEP_TIME) * 1000
      }
      account.list_data_points(entity_id,check_id,metric_name,options).data[:headers]
    end
  end
  tests('failure') do
    tests('#fail to list checks').raises(Fog::Rackspace::Monitoring::NotFound) do
      account.list_checks(-1)
    end
    tests('#fail to list check types').raises(ArgumentError) do
      account.list_check_types(-1)
    end
    # This test has been put on hold due to a bug that incorrectly returns 200 OK to this request
    # tests('#fail to list notifications').raises(ArgumentError) do
    #   account.list_notifications(-1)
    # end
    # This test has been put on hold due to a bug that incorrectly returns 200 OK to this request
    #tests('#fail to list metrics').raises(Fog::Rackspace::Monitoring::NotFound) do
      #account.list_metrics(-1,-1)
    #end
    tests('#fail: 1 argument instead of 0 for list_notification_plans').raises(ArgumentError) do
      account.list_notification_plans('fail')
    end
    tests('#fail to get list of data points').raises(Fog::Rackspace::Monitoring::BadRequest) do
      account.list_data_points(-1,-1,-1,-1).data
    end
  end
  account.delete_check(entity_id,check_id) unless Fog.mocking?
  account.delete_entity(entity_id) unless Fog.mocking?
end
