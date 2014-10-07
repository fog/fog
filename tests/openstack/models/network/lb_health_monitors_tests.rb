Shindo.tests("Fog::Network[:openstack] | lb_health_monitors", ['openstack']) do
  @lb_health_monitor = Fog::Network[:openstack].lb_health_monitors.create(:type => 'PING',
                                                                          :delay => 1,
                                                                          :timeout => 5,
                                                                          :max_retries => 10)
  @lb_health_monitors = Fog::Network[:openstack].lb_health_monitors

  tests('success') do

    tests('#all').succeeds do
      @lb_health_monitors.all
    end

    tests('#get').succeeds do
      @lb_health_monitors.get @lb_health_monitor.id
    end

  end

  @lb_health_monitor.destroy
end
