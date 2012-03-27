Shindo.tests('Fog::Storage[:ibm] | volume requests', ['ibm']) do

  @volume_format = {
    "id"            => String,
    "instanceId"    => Fog::Nullable::String,
    "name"          => String,
    "format"        => String,
    "state"         => Integer,
    "size"          => String,
    "offeringId"    => String,
    "owner"         => String,
    "createdTime"   => Integer,
    "location"      => String,
    "productCodes"  => Array,
  }

  @full_volume_format = @volume_format.merge({
    "ioPrice"       => {
      "rate"          => Float,
      "unitOfMeasure" => String,
      "countryCode"   => String,
      "effectiveDate" => Integer,
      "currencyCode"  => String,
      "pricePerQuantity"  => Integer,
    }
  })

  @volumes_format = {
    'volumes' => [ @volume_format ]
  }

  tests('success') do

    @volume_id    = nil
    @name         = "fog-test-volume" + Time.now.to_i.to_s(32)
    @format       = "RAW"
    @location_id  = "41"
    @size         = "256"
    @offering_id  = "20001208"

    @instance_id  = nil
    @image_id       = "20010001"
    @instance_type  = "BRZ32.1/2048/60*175"

    # Instance-using tests are pending, so don't create the key now
    # @key_name       = "fog-test-key-" + Time.now.to_i.to_s(32)
    # @key            = Fog::Compute[:ibm].keys.create(:name => @key_name)

    tests("#create_volume('#{@name}', '#{@offering_id}', '#{@format}', '#{@location_id}', '#{@size}')").formats(@volume_format) do
      data = Fog::Storage[:ibm].create_volume(@name, @offering_id, @format, @location_id, @size).body
      @volume_id = data['id']
      data
    end

    tests("#list_volumes").formats(@volumes_format) do
      Fog::Storage[:ibm].list_volumes.body
    end

    tests("#get_volume('#{@volume_id}')").formats(@full_volume_format) do
      Fog::Storage[:ibm].get_volume(@volume_id).body
    end

    # Tests which use this instance are pending
    # @instance_id = Fog::Compute[:ibm].create_instance(
    #   'fog-test-volume-instance-' + Time.now.to_i.to_s(32),
    #   @image_id,
    #   @instance_type,
    #   @location_id,
    #   :key_name => @key_name
    # ).body['instances'][0]['id']

    tests("#attach_volume('#{@instance_id}','#{@volume_id}')") do
      pending
      # TODO: Add assertions for this whenever it is properly supported
      Fog::Compute[:ibm].modify_instance(@instance_id, 'type' => 'attach', 'volume_id' => @volume_id)
    end

    tests("#detach_volume('#{@instance_id}','#{@volume_id}')") do
      pending
      # TODO: Add assertions for this whenever it is properly supported
      Fog::Compute[:ibm].modify_instance(@instance_id, 'type' => 'attach', 'volume_id' => @volume_id)
      Fog::Compute[:ibm].delete_instance(@instance_id)
    end

    Fog::Storage[:ibm].volumes.get(@volume_id).wait_for(Fog::IBM.timeout) { ready? }

    tests("#delete_volume('#{@volume_id}')") do
      returns(true) { Fog::Storage[:ibm].delete_volume(@volume_id).body['success'] }
    end

    # See above
    # @server = Fog::Compute[:ibm].servers.get(@instance_id)
    # @server.wait_for(Fog::IBM.timeout) { ready? }
    # @server.destroy
    # @key.wait_for(Fog::IBM.timeout) { instance_ids.empty? }
    # @key.destroy

  end

end
