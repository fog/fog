Shindo.tests('Slicehost#reboot_slice', 'slicehost') do
  tests('success') do

    @server = Slicehost[:slices].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogrebootslice')
    @server.wait_for { ready? }

    tests("#reboot_slice(#{@server.id})").formats(Slicehost::Formats::SLICE) do
      Slicehost[:slices].reboot_slice(@server.id).body
    end

    @server.wait_for { ready? }
    @server.destroy

  end

  tests('failure') do

    tests('#reboot_slice(0)').raises(Excon::Errors::Forbidden) do
      Slicehost[:slices].reboot_slice(0)
    end

  end
end
