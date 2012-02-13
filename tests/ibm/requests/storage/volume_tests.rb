Shindo.tests('Fog::Storage[:ibm] | volume requests', ['ibm']) do

  @combined_volume_format = {
    "id"            => String,
    "instanceId"    => String,
    "name"          => String,
    "format"        => String,
    "state"         => Integer,
    "size"          => String,
    "offeringId"    => String,
    "owner"         => String,
    "createdTime"   => Integer,
    "location"      => String,
    "productCodes"  => Array,
    "ioPrice"       => {
      "rate"          => Float,
      "unitOfMeasure" => String,
      "countryCode"   => String,
      "effectiveDate" => Integer,
      "currencyCode"  => String,
      "pricePerQuantity"  => Integer,
    }
  }

  @volumes_format = {
    'volumes'     => [ @combined_volume_format.reject { |k,v| k == "ioPrice" } ]
  }

  @volume_format = @combined_volume_format.reject { |k,v| k == "instanceId" }

  tests('success') do

    @volume_id    = nil
    @name         = "fog test volume"
    @format       = "raw"
    @location_id  = "101"
    @size         = "256"
    @offering_id  = "20001208"

    @instance_id  = nil
    @image_id       = "20015393"
    @instance_type  = "BRZ32.1/2048/60*175"
    @location       = "101"
    @public_key     = "test"

    tests("#create_volume('#{@name}', '#{@offering_id}', '#{@format}', '#{@location_id}', '#{@size}')").formats(@volume_format) do
      data = Fog::Storage[:ibm].create_volume(@name, @offering_id, @format, @location_id, @size).body
      @volume_id = data['id']
      data
    end

    tests("#list_volumes").formats(@volumes_format) do
      Fog::Storage[:ibm].list_volumes.body
    end

    tests("#get_volume('#{@volume_id}')").formats(@volume_format) do
      Fog::Storage[:ibm].get_volume(@volume_id).body
    end

    tests("#attach_volume('#{@instance_id}','#{@volume_id}')") do
      @instance_id = Fog::Compute[:ibm].create_instance(
        "fog test volume instance",
        @image_id,
        @instance_type,
        @location,
        :key_name => @public_key
      ).body['instances'][0]['id']
      # TODO: Add assertions for this whenever it is properly supported
      Fog::Compute[:ibm].modify_instance(@instance_id, 'type' => 'attach', 'volume_id' => @volume_id)
    end

    tests("#detach_volume('#{@instance_id}','#{@volume_id}')") do
      # TODO: Add assertions for this whenever it is properly supported
      Fog::Compute[:ibm].modify_instance(@instance_id, 'type' => 'attach', 'volume_id' => @volume_id)
      Fog::Compute[:ibm].delete_instance(@instance_id)
    end

    tests("#delete_volume('#{@volume_id}')") do
      returns(true) { Fog::Storage[:ibm].delete_volume(@volume_id).body['success'] }
    end

  end

end
