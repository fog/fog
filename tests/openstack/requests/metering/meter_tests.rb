Shindo.tests('Fog::Metering[:openstack] | meter requests', ['openstack']) do

  @sample_format = {
    'counter_name'      => String,
    'user_id'           => String,
    'resource_id'       => String,
    'timestamp'         => String,
    'resource_metadata' => Hash,
    'source'            => String,
    'counter_unit'      => String,
    'counter_volume'    => Float,
    'project_id'        => String,
    'message_id'        => String,
    'counter_type'      => String
  }

  @meter_format = {
    'user_id'     => String,
    'name'        => String,
    'resource_id' => String,
    'project_id'  => String,
    'type'        => String,
    'unit'        => String
  }
  tests('success') do
    tests('#list_meters').formats([@meter_format]) do
      Fog::Metering[:openstack].list_meters.body
    end

    tests('#get_samples').formats([@sample_format]) do
      Fog::Metering[:openstack].get_meter('test').body
    end

    tests('#get_statistics').formats([@sample_format]) do
      Fog::Metering[:openstack].get_meter('test').body
    end
  end
end
