Shindo.tests('Fog::Rackspace::Storage | directory', ['rackspace']) do

  @service = Fog::Storage[:rackspace]

  def container_meta_attributes
    @service.head_container(@instance.key).headers.reject {|k, v| !(k =~ /X-Container-Meta-/)}
  end

  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fog-directory-tests-#{rand(65536)}"
  }

   model_tests(@service.directories, directory_attributes, Fog.mocking?) do

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
        @service.instance_variable_set "@rackspace_cdn_ssl", true
        tests('ssl').returns(nil) do
          @instance.public_url
        end
        @service.instance_variable_set "@rackspace_cdn_ssl", nil
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
          @service.instance_variable_set "@rackspace_cdn_ssl", true
          tests('ssl').returns(0) do
            @instance.public_url =~ /https:\/\/.+\.ssl\./
          end
          @service.instance_variable_set "@rackspace_cdn_ssl", nil
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

   directory_attributes[:metadata] = {:draft => 'true'}

   tests('metadata') do

     model_tests(@service.directories, directory_attributes, Fog.mocking?) do
       tests('sets metadata on create').returns('true') do
         @instance.metadata.data
         container_meta_attributes["X-Container-Meta-Draft"]
       end
       tests('update metadata').returns({"X-Container-Meta-Draft"=>"true", "X-Container-Meta-Color"=>"green"}) do
         @instance.metadata[:color] = 'green'
         @instance.save
         container_meta_attributes
       end
       tests('set metadata to nil').returns({"X-Container-Meta-Draft"=>"true"}) do
         @instance.metadata[:color] = nil
         @instance.save
         container_meta_attributes
       end
       tests('delete metadata').returns({}) do
         @instance.metadata.delete(:draft)
         @instance.save
         container_meta_attributes
       end

       tests('should retrieve metadata when necessary') do
         @service.put_container(@instance.key, {"X-Container-Meta-List-Test"=>"true"} )
         dir = @service.directories.find {|d| d.key == @instance.key }
         returns(nil) { dir.instance_variable_get("@metadata") }
         returns('true') { dir.metadata[:list_test] }
       end

       tests("should reload metadata after calling reload").returns("42") do
         @service.put_container @instance.key, "X-Container-Meta-Answer" => 42
         @instance.reload
         @instance.metadata[:answer]
       end

       tests("should reload metadata after calling reload").returns("42") do
         @service.put_container @instance.key, "X-Container-Meta-Answer" => 42
         @instance.reload
         @instance.metadata[:answer]
       end

     end
   end

end
