Shindo.tests('Fog::Rackspace::Monitoring | notification_tests', ['rackspace','rackspace_monitoring']) do
  account = Fog::Rackspace::Monitoring.new
  notification_id = nil
  tests('success') do
    tests('#create new notification').formats(DATA_FORMAT) do
      pending if Fog.mocking?
      response = account.create_notification(:label => "Foo", :type => "email", :details => {:address => "test@test.com"}).data

      notification_id = response[:headers]["X-Object-ID"]
      response
    end
    tests('#get notification').formats(LIST_HEADERS_FORMAT) do
      account.get_notification(notification_id).data[:headers]
    end
    tests('#update notification').formats(DATA_FORMAT) do
      pending if Fog.mocking?

      options = {:testing => "Bar"}
      account.update_notification(notification_id,options).data
    end
    tests('#delete notification').formats(DELETE_DATA_FORMAT) do
      pending if Fog.mocking?
      account.delete_notification(notification_id).data
    end
  end
  tests('failure') do
    tests('#create new notification(-1)').raises(Fog::Rackspace::Monitoring::BadRequest) do
      pending if Fog.mocking?
      account.create_notification(:label => "")
    end
    tests('#get notification(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      pending if Fog.mocking?

      account.get_notification(-1)
    end
    tests('#update invalid notification(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      pending if Fog.mocking?
      options = { :testing => "Bar" }
      response = account.update_notification(-1,options)
    end
    tests('#delete notification(-1)').raises(Fog::Rackspace::Monitoring::NotFound) do
      pending if Fog.mocking?
      account.delete_notification(-1)
    end
  end
end
