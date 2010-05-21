Shindo.tests('Slicehost#get_slice', 'slicehost') do
  tests('success') do

    @server = Slicehost[:slices].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogrebootslice')

    tests("#get_slice(#{@server.id})").formats(Slicehost::Formats::SLICE) do
      Slicehost[:slices].get_slice(@server.id).body
    end

    @server.wait_for { ready? }
    @server.destroy

  end

  tests('failure') do

    tests('#get_slice(0)').raises(Excon::Errors::Forbidden) do
      Slicehost[:slices].get_slice(0)
    end

  end
end
