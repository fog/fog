Shindo.tests('Fog::Compute[:ibm] | address requests', ['ibm']) do

  @address_format = {
    "state"     => Integer,
    "offeringId"=> String,
    "location"  => String,
    "ip"        => String,
    "id"        => String,
    "mode"      => Integer,
    "hostname"  => String,
    "type"      => Integer,
    "instanceId" => Fog::Nullable::String,
    "vlan"      => Fog::Nullable::String,
  }

  # create_address doesn't return mode, hostname or type attributes
  @create_address_format = @address_format.reject { |k,v| ["mode", "hostname", "type"].include? k }
  # list_address returns everything
  @list_address_format   = { 'addresses' => [ @address_format ] }

  @address_id  = nil
  @location_id = "41"
  @offering_id = "20001223"

  tests('success') do

    tests("#create_address('#{@location_id}')").formats(@create_address_format) do
      data        = Fog::Compute[:ibm].create_address(@location_id, @offering_id).body
      @address_id = data['id']
      data
    end

    tests("#list_addresses").formats(@list_address_format) do
      Fog::Compute[:ibm].list_addresses.body
    end

    tests("#delete_address('#{@address_id}')") do
      Fog::Compute[:ibm].addresses.get(@address_id).wait_for(Fog::IBM.timeout) { ready? }
      returns(true) { Fog::Compute[:ibm].delete_address(@address_id).body['success'] }
    end

  end

end
