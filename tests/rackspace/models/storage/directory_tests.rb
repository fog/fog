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
     
     tests('#public_url') do
       
       tests('http').returns(nil) do
         @instance.public_url
        end

        @instance.cdn_cname = "my_cname.com"        
        tests('cdn_cname').returns(nil) do
          @instance.public_url
        end
        
        @instance.cdn_cname = nil
        service.instance_variable_set "@rackspace_cdn_ssl", true
        tests('ssl').returns(nil) do
          @instance.public_url
        end   
        service.instance_variable_set "@rackspace_cdn_ssl", nil             
     end
     
     tests('#ios_url').returns(nil) do
       @instance.ios_url
     end

     tests('#streaming_url').returns(nil) do
       @instance.streaming_url
     end
     
     tests('cdn') do
       @instance.public = true
       @instance.save
       
       tests('#public?').returns(true) do
         @instance.public?
       end

       tests('#public_url') do

         tests('http').returns(0) do
           @instance.public_url  =~ /http:\/\//
          end

          @instance.cdn_cname = "my_cname.com"        
          tests('cdn_cname').returns(0) do
            @instance.public_url  =~ /my_cname\.com/
          end

          @instance.cdn_cname = nil
          service.instance_variable_set "@rackspace_cdn_ssl", true
          tests('ssl').returns(0) do
            @instance.public_url =~ /https:\/\/.+\.ssl\./
          end   
          service.instance_variable_set "@rackspace_cdn_ssl", nil
       end

       tests('#ios_url').returns(0) do
         @instance.ios_url =~ /http:\/\/.+\.iosr\./
       end

       tests('#streaming_url').returns(0) do
         @instance.streaming_url =~ /http:\/\/.+\.stream\./
       end
       
     end
     tests("reload") do
       @instance.reload
       returns(nil) { @instance.instance_variable_get("@urls") }
       returns(nil) { @instance.instance_variable_get("@files") }
       returns(nil) { @instance.instance_variable_get("@public") }       
     end
   end
end