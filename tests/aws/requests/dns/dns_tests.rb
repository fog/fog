Shindo.tests('AWS::DNS | DNS requests', ['aws', 'dns']) do

  @test_domain = 'sample53-domain.com'
    
  tests( 'success') do

    tests('#create_hosted_zones') {
      
      test('simple zone') {
        pending if Fog.mocking?
  
        response = AWS[:dns].create_hosted_zone( @test_domain)
        if response.status == 201
          zone_id = response.body['HostedZone']['Id']
          response = AWS[:dns].delete_hosted_zone( zone_id)
          (response.status == 200) ? true : false
        end
      }
      
    }
    
    tests('#get_hosted_zones') {      
    }
    
    tests('#delete_hosted_zones') {
      
    }
    
    tests('#list_hosted_zones') {

      test( 'simple list') {
        pending if Fog.mocking?

        response = AWS[:dns].list_hosted_zones()
        response.status == 200
      }

    }
  
  end

  tests( 'failure') do
    tests('#create_hosted_zone') do
      
      tests('invalid domain name') {
        pending if Fog.mocking?

        raises( Excon::Errors::BadRequest) {
          response = AWS[:dns].create_hosted_zone( 'invalid-domain')
        }
      }
    end
    
    tests('#get_hosted_zone') do

      tests('for invalid zone ID') do
        pending if Fog.mocking?

        raises(Excon::Errors::BadRequest) {
          zone_id = 'dummy-id'
          response = AWS[:dns].get_hosted_zone( zone_id)
        }        
      end
    end
  
  end

  
end
