Shindo.tests('Fog::Rackspace::Storage | directory', ['rackspace']) do

  pending if Fog.mocking?

  @service = Fog::Storage[:rackspace]
  
  def container_meta_attributes
    @service.head_container(@instance.key).headers.reject {|k, v| !(k =~ /X-Container-Meta-/)}
  end
  
  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fog-directory-tests-#{rand(65536)}"
  }
  
   model_tests(@service.directories, directory_attributes, Fog.mocking?) do
     tests('#public_url').returns(nil) do
       @instance.public_url
     end     
   end
   
   directory_attributes[:metadata] = {:draft => 'true'}

   tests('metadata')  do
     pending if Fog.mocking?
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
       
       tests("should reload metadata after calling reload").returns(42) do
         @service.put_container @instance.key, "X-Container-Meta-Answer" => 42
         @instance.reload
         @instance.metadata[:answer]
       end
       
     end
   end
   
end