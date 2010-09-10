require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Compute.describe_images' do
  describe 'success' do

    it "should return proper attributes with no params" do
      actual = AWS[:compute].describe_images
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
      image['rootDeviceName'].should be_a(String) if image['rootDeviceName']
      ["ebs","instance-store"].should include(image['rootDeviceType'])
      image['rootDeviceName'].should be_a(String) if image['rootDeviceName']
    end

    it "should return proper attributes with params" do
      actual = AWS[:compute].describe_images('ImageId' => GENTOO_AMI)
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
      ["ebs","instance-store"].should include(image['rootDeviceType'])
      image['rootDeviceName'].should be_a(String) if image['rootDeviceName']
    end

  end
end
