Shindo.tests('Fog::Compute[:cloudstack] | create template requests', ['cloudstack']) do

  @create_template_format = {
    'createtemplateresponse' => {
      'id'                => Integer,
      'clusterid'         => Fog::Nullable::Integer,
      'clustername'       => Fog::Nullable::String,
      'created'           => Fog::Nullable::Time,
      'disksizeallocated' => Fog::Nullable::Integer,
      'disksizetotal'     => Fog::Nullable::Integer,
      'ipaddress'         => Fog::Nullable::String,
      'jobid'             => Fog::Nullable::Integer,
      'jobstatus'         => Fog::Nullable::String,
      'name'              => Fog::Nullable::String,
      'path'              => Fog::Nullable::String,
      'podid'             => Fog::Nullable::Integer,
      'podname'           => Fog::Nullable::String,
      'state'             => Fog::Nullable::String,
      'tags'              => Fog::Nullable::Array,
      'type'              => Fog::Nullable::String,
      'zoneid'            => Fog::Nullable::Integer,
      'zonename'          => Fog::Nullable::String
    }
  }

  tests('success') do

    tests('#create_template').formats(@create_template_format) do

      root_device_id = Cloudstack::Compute::Constants::CREATE_FROM_VOLUME_ID

      if Fog.mocking?
        template_name = "FogTest-#{Time.now.to_i}"
        templ = Fog::Compute[:cloudstack].create_template(
          template_name,
          template_name,
          Cloudstack::Compute::Constants::OS_TYPE_ID,
          {'volumeid' => root_device_id})

      else
        # TODO: Safely catch errors and delete created resources even in case of error
        vm,templ = Cloudstack::Compute::TestHelpers.deploy_vm_and_create_template(
          Cloudstack::Compute::Constants::SERVICE_OFFERING_ID,
          Cloudstack::Compute::Constants::TEMPLATE_ID,
          Cloudstack::Compute::Constants::FROM_ZONE_ID,
          Cloudstack::Compute::Constants::OS_TYPE_ID
        )

        Fog::Compute[:cloudstack].destroy_virtual_machine('id' => vm['listvirtualmachinesresponse']['virtualmachine'].first['id'])
        Fog::Compute[:cloudstack].delete_template(templ['createtemplateresponse']['id'])
      end

      templ
    end

  end

end