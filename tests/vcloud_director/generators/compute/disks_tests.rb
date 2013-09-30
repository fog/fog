Shindo.tests('Compute::VcloudDirector | disks generator', ['vclouddirector', 'xsd']) do

  require 'fog/vcloud_director/generators/compute/disks'

  tests('#generate_xml').returns(String) do
    @items =
      {:disks=>
       [{:address=>0,
         :description=>"SCSI Controller",
         :name=>"SCSI Controller 0",
         :id=>2,
         :resource_sub_type=>"VirtualSCSI",
         :resource_type=>6},
        {:address_on_parent=>0,
         :description=>"Hard disk",
         :name=>"Hard disk 1",
         :id=>2000,
         :parent=>2,
         :resource_type=>17,
         :capacity=>16384,
         :bus_sub_type=>"VirtualSCSI",
         :bus_type=>6},
        {:address=>0,
         :description=>"IDE Controller",
         :name=>"IDE Controller 0",
         :id=>3,
         :resource_type=>5}]}
    @xml = Fog::Generators::Compute::VcloudDirector::Disks.new(@items).generate_xml
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
