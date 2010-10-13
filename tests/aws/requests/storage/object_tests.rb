Shindo.tests('AWS::Storage | object requests', ['aws']) do

  @directory = AWS[:storage].directories.create(:key => 'fogobjecttests')

  tests('success') do

    tests("#put_object('#{@directory.identity}', 'fog_object', lorem_file)").succeeds do
      AWS[:storage].put_object(@directory.identity, 'fog_object', lorem_file)
    end

    tests("#get_object")

    tests("#delete_object('#{@directory.identity}', 'fog_object')").succeeds do
      AWS[:storage].delete_object(@directory.identity, 'fog_object')
    end

  end

  tests('failure') do

    tests("#put_object('fognonbucket', 'fog_object', lorem_file)").raises(Excon::Errors::NotFound) do
      AWS[:storage].put_object('fognonbucket', 'fog_object', lorem_file)
    end

    tests("#delete_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      AWS[:storage].delete_object('fognonbucket', 'fog_non_object')
    end

  end

  @directory.destroy

end