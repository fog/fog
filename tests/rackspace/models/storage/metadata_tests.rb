require 'fog/rackspace/models/storage/metadata'
require 'fog/rackspace/models/storage/directory'
require 'fog/rackspace/models/storage/file'

Shindo.tests('Fog::Rackspace::Storage | metadata', ['rackspace']) do
  tests('Directory') do
    @directory = Fog::Storage::Rackspace::Directory.new
    tests('#to_key') do
      tests('valid key').returns(:image_size) do
        metadata = Fog::Storage::Rackspace::Metadata.new @directory
        metadata.send(:to_key, "X-Container-Meta-Image-Size")
      end
      tests('invalid key').returns(nil) do
        metadata = Fog::Storage::Rackspace::Metadata.new @directory
        metadata.send(:to_key, "bad-key")
      end
    end
  
    tests('#to_header_key') do
      metadata = Fog::Storage::Rackspace::Metadata.new @directory
    
      tests('key to add').returns("X-Container-Meta-Thumbnail-Image") do
        metadata.send(:to_header_key, :thumbnail_image, true)
      end
    
      tests('key to remove').returns("X-Remove-Container-Meta-Thumbnail-Image") do
        metadata.send(:to_header_key, :thumbnail_image, nil)
      end    
    end
  
    tests('#to_headers').returns({"X-Container-Meta-Preview"=>true, "X-Remove-Container-Meta-Delete-Me"=>1}) do
      metadata = Fog::Storage::Rackspace::Metadata.new @directory
      metadata[:preview] = true
      metadata[:delete_me] = nil
    
      metadata.to_headers    
    end
  
  tests("#from_headers").returns({:my_boolean=>"true", :my_integer=>"42", :my_string=>"I am a string"}) do
    headers = {
      "X-Container-Meta-My-Integer"=> "42",
      "X-Container-Meta-My-Boolean"=> "true", 
      "X-Container-Meta-My-String"=> "I am a string" 
    }

      metadata = Fog::Storage::Rackspace::Metadata.from_headers @directory, headers
      metadata.data
    end
  
     tests("#delete").returns({"X-Remove-Container-Meta-Delete-Me"=>1}) do
       metadata = Fog::Storage::Rackspace::Metadata.new @directory
        metadata.delete(:delete_me)

        metadata.to_headers
     end
   end


   tests('File') do
     @file = Fog::Storage::Rackspace::File.new
     tests('#to_key') do
       tests('valid key').returns(:image_size) do
         metadata = Fog::Storage::Rackspace::Metadata.new @file
         metadata.send(:to_key, "X-Object-Meta-Image-Size")
       end
       tests('invalid key').returns(nil) do
         metadata = Fog::Storage::Rackspace::Metadata.new @file
         metadata.send(:to_key, "bad-key")
       end
     end

     tests('#to_header_key') do
       metadata = Fog::Storage::Rackspace::Metadata.new @file

       tests('key to add').returns("X-Object-Meta-Thumbnail-Image") do
         metadata.send(:to_header_key, :thumbnail_image, true)
       end

       tests('key to remove').returns("X-Remove-Object-Meta-Thumbnail-Image") do
         metadata.send(:to_header_key, :thumbnail_image, nil)
       end    
     end

     tests('#to_headers').returns({"X-Object-Meta-Preview"=>true, "X-Remove-Object-Meta-Delete-Me"=>1}) do
       metadata = Fog::Storage::Rackspace::Metadata.new @file
       metadata[:preview] = true
       metadata[:delete_me] = nil

       metadata.to_headers    
     end

     tests("#from_headers").returns({:my_boolean=>"true", :my_integer=>"42", :my_string=>"I am a string"}) do
       headers = {
         "X-Object-Meta-My-Integer"=> "42",
         "X-Object-Meta-My-Boolean"=> "true", 
         "X-Object-Meta-My-String"=> "I am a string"
       }

       metadata = Fog::Storage::Rackspace::Metadata.from_headers @file, headers
       metadata.data
     end

      tests("#delete").returns({"X-Remove-Object-Meta-Delete-Me"=>1}) do
        metadata = Fog::Storage::Rackspace::Metadata.new @file
         metadata.delete(:delete_me)

         metadata.to_headers
      end
    end
      
   tests("#respond_to?") do
     tests('Should respond to all of the methods in Hash class').returns(true) do
       metadata = Fog::Storage::Rackspace::Metadata.new @file
       Hash.instance_methods.all? {|method| metadata.respond_to?(method)}
     end
     tests('Should respond to all of the methods in the Metadata class').returns(true) do
       metadata = Fog::Storage::Rackspace::Metadata.new @file
       metadata.methods.all? {|method| metadata.respond_to?(method)}
     end
   end
   
   tests("#method_missing").returns(true) do
     metadata = Fog::Storage::Rackspace::Metadata.new @file
      metadata[:test] = true
      metadata[:test]
   end
end