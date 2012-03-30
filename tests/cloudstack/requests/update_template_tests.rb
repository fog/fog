Shindo.tests('Fog::Compute[:cloudstack] | update template requests', ['cloudstack']) do

  @update_template_format = {
    "updatetemplateresponse" => {
      "template" =>{
        "ostypename"  => String,
        "name"        => String,
        "hypervisor"  => String,
        "format"      => String,
        "ispublic"    => Fog::Boolean,
        "domain"      => String,
        "account"     => String,
        "isfeatured"  => Fog::Boolean,
        "displaytext" => String,
        "ostypeid"    => Integer,
        "isready"     => Fog::Boolean,
        "id"          => Integer,
        "domainid"    => Integer,
        "crossZones"  => Fog::Boolean,
        "created"     => String
      }
    }
  }

  tests('success') do
    tests('#update_template').formats(@update_template_format) do
      Fog::Compute[:cloudstack].update_template(213, {'bootable' => true})
    end
  end
end