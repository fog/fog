Shindo.tests('Fog::Compute[:cloudstack] | list template permissions requests', ['cloudstack']) do

  @list_template_permissions_format = {
            "listtemplatepermissionsresponse" => {
              "templatepermission" => {
                "ispublic"  => Fog::Boolean,
                "account"   => Array,
                "id"        => Integer,
                "domainid"  => Integer
              }
            }
          }

  tests('success') do

    tests('#list_template_permissions').formats(@list_template_permissions_format) do
      Fog::Compute[:cloudstack].list_template_permissions(206)
    end

  end

end