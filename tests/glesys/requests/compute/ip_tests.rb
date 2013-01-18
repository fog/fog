Shindo.tests('Fog::Compute[:glesys] | ip requests', ['glesys']) do

  @free_ip = nil
  @ips = nil

  tests('success') do

    tests("#ip_list_own()").formats(Glesys::Compute::Formats::Ips::IPLIST) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].ip_list_own.body['response']
    end

    tests("#ip_list_free(:datacenter => 'Falkenberg, :platform => 'Xen', :ipversion => 4)"
    ).formats(Glesys::Compute::Formats::Ips::IPLIST_ALL) do
      pending if Fog.mocking?
      ips = Fog::Compute[:glesys].ip_list_free(
        :datacenter => "Falkenberg",
        :platform   => "Xen",
        :ipversion  => 4
      )
      @free_ip = ips.body['response']['iplist']['ipaddresses'].first
      ips.body['response']
    end

    tests("#ip_take(:datacenter => 'Falkenberg', :platform => 'Xen', :ipversion => 4, :ipaddress => #{@free_ip})"
    ).formats(Glesys::Compute::Formats::Ips::IPLIST_CATCH_RELEASE) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].ip_take(
        :datacenter => "Falkenberg",
        :platform   => "Xen",
        :ipversion  => 4,
        :ipaddress  => @free_ip
      ).body['response']
    end

    tests("#ip_release(:ipaddress => '#{@free_ip}', :ipversion => 4)"
    ).formats(Glesys::Compute::Formats::Ips::IPLIST_CATCH_RELEASE) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].ip_release(
        :ipaddress => @free_ip,
        :ipversion => 4
      ).body['response']
    end

    # ip_details()
    # ip_add()
    # ip_remove()

 end

  tests('failure') do

    tests("#ip_take_argument_error()").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      ip = Fog::Compute[:glesys].ips.new(
        :datacenter => "Falkenberg",
        :platform   => "Xen",
        :version    => 4,
        :ip         => "127.0.0.1"
      )
      ip.take
    end

  end


end
