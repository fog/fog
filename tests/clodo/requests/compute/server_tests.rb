Shindo.tests('Fog::Compute[:clodo] | server requests', ['clodo']) do

  @server_format = {
    'addresses' => {
      'public'  => [String]
    },
    'id'        => Integer,
    'imageId'   => Integer,
    'name'      => String,
    'status'    => String
  }

  @server_create_format = {
    'name'      => String,
    'adminPass' => String,
    'imageId'   => String,
    'id'        => Integer
  }


  @clodo = Fog::Compute::Clodo.new

  tests('success') do
    tests('- create_server(541)').formats(@server_create_format) do
      data = @clodo.create_server(541,{:vps_type => 'ScaleServer'}).body['server']
      @server_id = data['id']
      data
    end
  end

  tests('failure') do
    tests('- create_server(0)').raises(Excon::Errors::BadRequest) do
      data = @clodo.create_server(0,{:vps_type => 'ScaleServer'}).body['server']
      @server_id = data['id']
      data
    end
  end
end
