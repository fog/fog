Shindo.tests('Compute::VcloudDirector | NetworkConnectionSection generator', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/vm_network'

  tests('#generate_xml').returns(String) do
    @attrs =
      {:type=>"application/vnd.vmware.vcloud.networkConnectionSection+xml",
       :href=>
        "https://example.com/api/vApp/vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae/networkConnectionSection/",
       :id=>"vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae",
       :primary_network_connection_index=>0,
       :network=>"DevOps - Dev Network Connection",
       :needs_customization=>true,
       :network_connection_index=>0,
       :ip_address=>"10.192.0.130",
       :is_connected=>true,
       :mac_address=>"00:50:56:01:00:8d",
       :ip_address_allocation_mode=>"POOL"}
    @xml = Fog::Generators::Compute::VcloudDirector::VmNetwork.new(@attrs).generate_xml
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
