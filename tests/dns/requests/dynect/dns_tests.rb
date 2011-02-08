Shindo.tests('Dynect::dns | DNS requests', ['dynect', 'dns']) do
  tests( 'success') do
    test ('start api session') do

      response = Dynect[:dns].session
      if response.status == 200
        @auth_token = response.body['token']
      end

      response.status == 200
    end
  end
end
