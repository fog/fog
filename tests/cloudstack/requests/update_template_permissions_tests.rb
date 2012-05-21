Shindo.tests('Fog::Compute[:cloudstack] | update template permissions requests', ['cloudstack']) do

  @update_template_permissions_format = {
    "updatetemplatepermissionsresponse" => {
      "success"     => Fog::Nullable::String,
      "displaytext" => Fog::Nullable::String
    }
  }

  tests('success') do

    tests('#update_template_permissions').formats(@update_template_permissions_format) do
      Fog::Compute[:cloudstack].update_template_permissions(Cloudstack::Compute::Constants::TEMPLATE_ID_TO_MAKE_PUBLIC_AND_BOOTABLE, 'ispublic' => true)
    end
  end

end