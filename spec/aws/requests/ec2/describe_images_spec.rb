require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'EC2.describe_images' do

  it "should return proper attributes with no params" do
    actual = ec2.describe_images
    actual.body['requestId'].should be_a(String)
    image = actual.body['imagesSet'].first
    image['architecture'].should be_a(String)
    image['imageId'].should be_a(String)
    image['imageLocation'].should be_a(String)
    image['imageOwnerId'].should be_a(String)
    image['imageState'].should be_a(String)
    image['imageType'].should be_a(String)
    [false, true].should include(image['isPublic'])
    image['kernelId'].should be_a(String) if image['kernelId']
    image['platform'].should be_a(String) if image['platform']
    image['ramdiskId'].should be_a(String) if image['ramdiskId']
  end
  
  it "should return proper attributes with params" do
    actual = ec2.describe_images('ImageId' => 'ami-5ee70037')
    actual.body['requestId'].should be_a(String)
    image = actual.body['imagesSet'].first
    image['architecture'].should be_a(String)
    image['imageId'].should be_a(String)
    image['imageLocation'].should be_a(String)
    image['imageOwnerId'].should be_a(String)
    image['imageState'].should be_a(String)
    image['imageType'].should be_a(String)
    [false, true].should include(image['isPublic'])
    image['kernelId'].should be_a(String) if image['kernelId']
    image['platform'].should be_a(String) if image['platform']
    image['ramdiskId'].should be_a(String) if image['ramdiskId']
  end

end
