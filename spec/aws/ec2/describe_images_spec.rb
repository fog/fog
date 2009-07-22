require File.dirname(__FILE__) + '/../../spec_helper'

describe 'EC2.describe_images' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_images
    actual.body[:request_id].should be_a(String)
    image = actual.body[:image_set].first
    image[:architecture].should be_a(String)
    image[:image_id].should be_a(String)
    image[:image_location].should be_a(String)
    image[:image_owner_id].should be_a(String)
    image[:image_state].should be_a(String)
    image[:image_type].should be_a(String)
    [false, true].should include(image[:is_public])
    # image[:kernel_id].should be_a(String)
    # image[:platform].should be_a(String)
    # image[:ramdisk_id].should be_a(String)
  end
  
  it "should return proper attributes with params" do
    actual = ec2.describe_images(:image_id => 'ami-5ee70037')
    actual.body[:request_id].should be_a(String)
    image = actual.body[:image_set].first
    image[:architecture].should be_a(String)
    image[:image_id].should be_a(String)
    image[:image_location].should be_a(String)
    image[:image_owner_id].should be_a(String)
    image[:image_state].should be_a(String)
    image[:image_type].should be_a(String)
    [false, true].should include(image[:is_public])
    # image[:kernel_id].should be_a(String)
    # image[:platform].should be_a(String)
    # image[:ramdisk_id].should be_a(String)
  end

end
