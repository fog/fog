Shindo.tests('Compute::VcloudDirector | GuestCustomizationSection generator', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/customization'

  tests('#generate_xml').returns(String) do
    @attrs =
      {:type=>"application/vnd.vmware.vcloud.guestCustomizationSection+xml",
       :href=>
        "https://example.com/api/vApp/vm-2bbbf556-55dc-4974-82e6-aa6e814f0b64/guestCustomizationSection/",
       :id=>"vm-2bbbf556-55dc-4974-82e6-aa6e814f0b64",
       :enabled=>false,
       :change_sid=>false,
       :virtual_machine_id=>"2bbbf556-55dc-4974-82e6-aa6e814f0b64",
       :join_domain_enabled=>false,
       :use_org_settings=>false,
       :admin_password_enabled=>false,
       :admin_password_auto=>true,
       :reset_password_required=>false,
       :customization_script=>"hola\nmundo",
       :has_customization_script=>true,
       :computer_name=>"DEVWEB-001"}
    @xml = Fog::Generators::Compute::VcloudDirector::Customization.new(@attrs).generate_xml
    @xml.class
  end

  tests('#parse').returns(Nokogiri::XML::Document) do
    @doc = Nokogiri::XML::Document.parse(@xml)
    @doc.class
  end

  tests('#validate').returns([]) do
    pending unless VcloudDirector::Generators::Helpers.have_xsd?
    VcloudDirector::Generators::Helpers.validate(@doc)
  end

end
