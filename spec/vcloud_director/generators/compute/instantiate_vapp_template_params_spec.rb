require './spec/vcloud_director/spec_helper.rb'
require 'minitest/autorun'
require 'nokogiri'
require './lib/fog/vcloud_director/generators/compute/instantiate_vapp_template_params.rb'

describe Fog::Generators::Compute::VcloudDirector::InstantiateVappTemplateParams do
  
  let(:xml) do 
    params = {
      :name => 'VAPP_NAME',
      :Description => 'MY VAPP',
      :InstantiationParams => {
        :NetworkConfig => [
          {
            :networkName => 'NETWORK',
            :networkHref => 'http://vcloud/api/network/123456789',
            :fenceMode => 'bridged'
          }
        ]
      },
      :Source => 'http://vcloud/vapp_template/1234',
      :source_vms => [
        {
          :name => 'VM1',
          :href => 'http://vcloud/api/vm/12345',
          :StorageProfileHref => 'http://vcloud/storage/123456789'
        },
        {
          :name => 'VM2',
          :href => 'http://vcloud/api/vm/12345',
          :StorageProfileHref => 'http://vcloud/storage/123456789'
        }
      ]
      
    }

    output = Fog::Generators::Compute::VcloudDirector::InstantiateVappTemplateParams.new(params).generate_xml
    Nokogiri::XML(output)
  end
  
  it "Generates InstantiateVAppTemplateParams" do
    xml.xpath('//InstantiateVAppTemplateParams').must_be_instance_of Nokogiri::XML::NodeSet 
  end
  
  it "Has a valid Network" do
    node = xml.xpath('//xmlns:NetworkConfigSection')
    
    xml.xpath("//xmlns:NetworkConfig")[0].attr('networkName').must_equal "NETWORK"    
    xml.xpath('//xmlns:ParentNetwork')[0].attr('href').must_equal 'http://vcloud/api/network/123456789'
    
  end
  
  it "Has valid source VAPP info" do
    node = xml.xpath('//xmlns:Source[@href="http://vcloud/vapp_template/1234"]')
    node.length.must_equal 1
  end
  
  it "Has valid source VM info" do
    
    xml.xpath('//xmlns:StorageProfile[@href="http://vcloud/storage/123456789"]').length.must_equal 2
  end
  
  it "Allows New VM Parameters" do
    nodes = xml.xpath('//xmlns:VmGeneralParams')
    nodes.length.must_equal 2   
  end
  
end