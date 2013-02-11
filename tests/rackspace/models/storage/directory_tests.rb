Shindo.tests('Fog::Rackspace::Storage | directories', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Storage[:rackspace]
  
  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fog-directory-tests-#{rand(65536)}"
  }
  
   model_tests(service.directories, directory_attributes, Fog.mocking?) do
     
     tests('#public?').returns(false) do
       @instance.public?
     end
     
     tests('#public_url').returns(nil) do
       @instance.public_url
     end
     
     tests('cdn') do
       @instance.public = true
       @instance.save
       
       tests('#public?').returns(true) do
         @instance.public?
       end

       tests('#public_url').returns(false) do
         @instance.public_url.nil?
       end
     end
     tests("reload") do
       @instance.reload
       returns(nil) { @instance.instance_variable_get("@public") }
       returns(nil) { @instance.instance_variable_get("@public_url") }
       returns(nil) { @instance.instance_variable_get("@files") }       
     end
   end
end