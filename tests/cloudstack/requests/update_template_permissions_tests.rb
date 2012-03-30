Shindo.tests('Fog::Compute[:cloudstack] | update template permissions requests', ['cloudstack']) do

  @update_template_permissions_format = {
    "updatetemplatepermissionsresponse" => {
      "success"     => Fog::Boolean,
      "displaytext" => Fog::Nullable::String
    }
  }

  tests('success') do

    tests('#update_template_permissions').formats(@update_template_permissions_format) do
      Fog::Compute[:cloudstack].update_template_permissions(206, 'ispublic' => true)
    end
  end

end