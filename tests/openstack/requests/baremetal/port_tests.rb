Shindo.tests('Fog::Baremetal[:openstack] | Baremetal port requests', ['openstack']) do
  openstack = Fog::Identity[:openstack]

  @port_format = {
    'address' => String,
    'uuid'    => String
  }

# {"node_uuid"=>"ebf4e459-ddd6-4ce9-bef5-5181987cb62c", "uuid"=>"82a26de6-6af5-4cd3-a076-a5af1a75d457", "links"=>[{"href"=>"http://192.0.2.1:6385/v1/ports/82a26de6-6af5-4cd3-a076-a5af1a75d457", "rel"=>"self"}, {"href"=>"http://192.0.2.1:6385/ports/82a26de6-6af5-4cd3-a076-a5af1a75d457", "rel"=>"bookmark"}], "extra"=>{}, "created_at"=>"2015-01-15T09:22:23.673409+00:00", "updated_at"=>nil, "address"=>"00:c2:08:85:de:ca"} does not match {"address"=>String, "uuid"=>String, "created_at"=>String, "updated_at"=>String, "extra"=>Hash, "node_uuid"=>String}



  @detailed_port_format = {
    'address'    => String,
    'uuid'       => String,
    'created_at' => String,
    'updated_at' => Fog::Nullable::String,
    'extra'      => Hash,
    'node_uuid'  => String,
    'links'      => Array
  }

  tests('success') do
    tests('#list_ports').data_matches_schema({'ports' => [@port_format]}) do
      Fog::Baremetal[:openstack].list_ports.body
    end

    tests('#list_ports_detailed').data_matches_schema({'ports' => [@detailed_port_format]}) do
      Fog::Baremetal[:openstack].list_ports_detailed.body
    end

    tests('#create_port').data_matches_schema(@detailed_port_format) do
      node_attributes = {:driver => 'pxe_ipmitool'}
      @instance = Fog::Baremetal[:openstack].create_node(node_attributes).body

      port_attributes = {:address => '00:c2:08:85:de:ca',
                         :node_uuid => @instance['uuid']}
      @port = Fog::Baremetal[:openstack].create_port(port_attributes).body
    end

    tests('#get_port').data_matches_schema(@detailed_port_format) do
      Fog::Baremetal[:openstack].get_port(@port['uuid']).body
    end

    tests('#patch_port').data_matches_schema(@detailed_port_format) do
      Fog::Baremetal[:openstack].patch_port(
          @port['uuid'],
          [{'op' => 'add', 'path' => '/extra/name', 'value' => 'eth1'}]).body
    end

    tests('#delete_port').succeeds do
      Fog::Baremetal[:openstack].delete_port(@port['uuid'])
      Fog::Baremetal[:openstack].delete_node(@instance['uuid'])
    end
  end
end
