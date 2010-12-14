USERNAME=''
PASSWORD=''
TEST_DOMAIN = 'sample53-domain.com.'

Shindo.tests('Zerigo::Compute | DNS requests', ['zerigo', 'dns']) do
  
  #connect to Zerigo
  # options = { :zerigo_user => USERNAME, :zerigo_password => PASSWORD }    
  # @zerigo = Fog::Zerigo::Compute.new( options)
  
  tests( 'success') do

    tests('#count_hosts') do 
    end
    
    tests('#count_zones') do 
    end
    
    tests('#create_host') do 
    end
    
    tests('#create_zone') do 
    end
    
    tests('#delete_host') do 
    end
    
    tests('#find_hosts') do 
    end
    
    tests('#get_host') do 
    end
    
    tests('#get_zone') do 
    end
    
    tests('#get_zone_stats') do 
    end
    
    tests('#list_hosts') do 
    end
    
    tests('#list_zones') do 
    end
    
    tests('#update_host') do 
    end
    
    tests('#update_zone') do 
    end
    
  end
  
  tests( 'failure') do
  end
    
end
