Shindo.tests('Fog::Compute[:ibm] | image requests', ['ibm']) do

  @image_format  = {
    'state'         => Integer,
    'visibility'    => String,
    'platform'      => String,
    'architecture'  => String,
    'owner'         => String,
    'createdTime'   => Integer,
    'location'      => String,
    'productCodes'  => Array,
    'name'          => String,
    'id'            => String,
    'description'   => String,
    'supportedInstanceTypes'  => Array,
    'manifest'      => String,
    'documentation' => String   
  }
  
  # TODO: Actually check this format
  @product_code_format = {
    'detail'        => String,
    'label'         => String,
    'price'         => @price_format,
    'id'            => String  
  }
  
  # TODO: Actually check this format
  @price_format = {
    'rate'          => Float,
    'unitOfMeasure' => String,
    'effectiveDate' => Integer,
    'currencyCode'  => String,
    'pricePerQuantity'  => Integer
  }
  
  @images_format = {
    'images'     => [ @image_format ]
  }

  @create_image_format = {
    "name"        => String,
    "createdTime" => Integer,
    "productCodes"=> Array,
    "id"          => String,
    "description" => String,
    "visibility"  => String,
    "state"       => Integer
  }

  @instance_id    = nil
  @name           = "fog test image instance"
  @image_id       = "20015393"
  @instance_type  = "BRZ32.1/2048/60*175"
  @location       = "101"
  @public_key     = "test"

  @id             = nil
  @cloned_id      = nil
  @image_name     = "fog test create image"


  tests('success') do
  
    tests("#list_images").formats(@images_format) do
      Fog::Compute[:ibm].list_images.body
    end
    
    tests('#get_image').formats(@image_format) do
      Fog::Compute[:ibm].get_image("20015393").body
    end
    
    tests('#create_image').formats(@create_image_format) do
      response = Fog::Compute[:ibm].create_instance(
        @name, 
        @image_id, 
        @instance_type, 
        @location, 
        @public_key, 
        @options
      ).body
      @instance_id  = response['instances'][0]['id']
      data          = Fog::Compute[:ibm].create_image(@instance_id, @image_name, "").body
      @id           = data['id']
      data 
    end
    
    tests('#clone_image') do
      data = Fog::Compute[:ibm].clone_image(@image_id, "fog test clone image", "").body
      @cloned_id = data['ImageID']
      returns(String) { data['ImageID'].class }
    end
  
    tests('#delete_image') do 
      returns(true) { Fog::Compute[:ibm].delete_image(@id).body['success'] } 
      returns(true) { Fog::Compute[:ibm].delete_image(@cloned_id).body['success'] } 
    end
  
  end

end