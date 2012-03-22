Shindo.tests('Fog::Compute[:ibm] | image requests', ['ibm']) do

  @image_format  = {
    'state'         => Integer,
    'visibility'    => String,
    'platform'      => String,
    'owner'         => String,
    'architecture'  => Fog::Nullable::String,
    'createdTime'   => Integer,
    'location'      => String,
    'productCodes'  => Array,
    'name'          => String,
    'id'            => String,
    'description'   => String,
    'supportedInstanceTypes'  => Array,
    'manifest'      => Fog::Nullable::String,
    'documentation' => Fog::Nullable::String,
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
  @name           = "fog-test-image-instance-" + Time.now.to_i.to_s(32)
  @image_id       = "20010001"
  @instance_type  = "BRZ32.1/2048/60*175"
  @location       = "41"

  @id             = nil
  @cloned_id      = nil
  @image_name     = "fog test create image"

  @key_name       = "fog-test-key-" + Time.now.to_i.to_s(32)
  @key            = Fog::Compute[:ibm].keys.create(:name => @key_name)

  tests('success') do

    tests("#list_images").formats(@images_format) do
      Fog::Compute[:ibm].list_images.body
    end

    tests('#get_image').formats(@image_format) do
      Fog::Compute[:ibm].get_image("20010001").body
    end

    tests('#create_image').formats(@create_image_format) do
      response = Fog::Compute[:ibm].create_instance(
        @name,
        @image_id,
        @instance_type,
        @location,
        :key_name => @key_name
      ).body
      @instance_id  = response['instances'][0]['id']
      Fog::Compute[:ibm].servers.get(@instance_id).wait_for(Fog::IBM.timeout) { ready? }
      data          = Fog::Compute[:ibm].create_image(@instance_id, @image_name, "").body
      @id           = data['id']
      data
    end

    tests('#clone_image') do
      clone_name = 'fog-test-clone-image-' + Time.now.to_i.to_s(32)
      data = Fog::Compute[:ibm].clone_image(@image_id, clone_name, clone_name).body
      @cloned_id = data['ImageID']
      returns(String) { data['ImageID'].class }
    end

    tests('#delete_image') do
      pending
      returns(true) { Fog::Compute[:ibm].delete_image(@id).body['success'] }
      returns(true) { Fog::Compute[:ibm].delete_image(@cloned_id).body['success'] }
    end

    @server = Fog::Compute[:ibm].servers.get(@instance_id)
    @server.wait_for(Fog::IBM.timeout) { ready? }
    @server.destroy
    @key.wait_for(Fog::IBM.timeout) { instance_ids.empty? }
    @key.destroy

  end

end
