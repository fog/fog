require 'fog/cloudstack'
require 'fog/compute'

describe "My behaviour" do

  it "should do something" do

    #To change this template use File | Settings | File Templates.
    cloudstack = Fog::Compute.new(
        :provider =>           'Cloudstack',
        :cloudstack_host=>     '172.17.4.111',
        :cloudstack_port=>     '8080',
        :cloudstack_scheme=>   'http',
        :cloudstack_api_key=>  '4WnS4I4jSy6QgtxBdzl5dz6NEO2RJVslCWe_6ijI_5XzJqmPtJCIdX_KNfp5HxtP_VPR8AjfiNuclEkCrHSB8A',
        :cloudstack_secret_access_key=> 'lZR3lh34OaxzVfDpfO49MKbZHaUaR7gWeEUlD4Wafc5iW8o8H4_cURJPj-uvglwUmZPvgnV7uX1oOP3UO1XtjQ'
    )
    volume = cloudstack.volumes.create(
        :name => 'test_volume_jiangqi',
        :disk_offering_id => '074ea146-e6f5-4d2f-8367-a61e9c55989e',
        :zone_id => '7da86d6b-2bfe-485d-94de-fd3a3522fc0f'
    )
  end
end