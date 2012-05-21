Shindo.tests('Fog::Compute[:cloudstack] | delete template requests', ['cloudstack']) do

  @delete_template_format = {
    "deletetemplateresponse" => {
      "jobid"       => Integer,
      "success"     => Fog::Nullable::Boolean,
      "displaytext" => Fog::Nullable::String
    }
  }

  tests('success') do

    tests('#delete_template').formats(@delete_template_format) do
      if Fog.mocking?
        delresponse = Fog::Compute[:cloudstack].delete_template(Cloudstack::Compute::Constants::TEMPLATE_ID)
      else
        vm,templ = Cloudstack::Compute::TestHelpers.deploy_vm_and_create_template(
          Cloudstack::Compute::Constants::SERVICE_OFFERING_ID,
          Cloudstack::Compute::Constants::TEMPLATE_ID,
          Cloudstack::Compute::Constants::FROM_ZONE_ID,
          Cloudstack::Compute::Constants::OS_TYPE_ID
        )

        Fog::Compute[:cloudstack].destroy_virtual_machine('id' => vm['listvirtualmachinesresponse']['virtualmachine'].first['id'])
        delresponse = Fog::Compute[:cloudstack].delete_template(templ['createtemplateresponse']['id'])
      end

      delresponse
    end
  end

end