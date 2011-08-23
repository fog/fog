require 'spec_helper'
require 'storage/aws/aws_spec_helper'

describe Fog::Storage::AWS do

  describe "canned ACL" do
    it "should raise an error with an invalid canned ACL" do
      lambda { 
        aws_storage.put_bucket_acl('bucket', 'invalid') 
      }.should raise_error(Excon::Errors::BadRequest, "invalid x-amz-acl")
    end
    it "should produce a request with an x-amz-acl header" do
      hash = aws_storage.put_bucket_acl('bucket', 'private')
      hash[:body].should == ""
      hash[:expects].should == 200
      hash[:headers]["x-amz-acl"].should == "private"
      hash[:headers]["Content-Type"].should == "application/json"      
      hash[:host].should == "bucket.s3.amazonaws.com"
      hash[:method].should == "PUT"
      hash[:path].should be_nil
      hash[:query].should == { "acl" => nil }
    end
  end
  
  describe "xml ACL" do
    it "sends valid ACL XML" do
      hash = aws_storage.put_bucket_acl('bucket', {
        'Owner' => { 'ID' => "8a6925ce4adf5f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
        'AccessControlList' => [
          { 
            'Grantee' => { 'ID' => "8a6925ce4adf588a4532142d3f74dd8c71fa124b1ddee97f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" }, 
            'Permission' => "FULL_CONTROL" 
          }
        ]
      })
      hash[:body].should == <<-BODY
<AccessControlPolicy>
  <Owner>
    <ID>8a6925ce4adf5f21c32aa379004fef</ID>
    <DisplayName>mtd@amazon.com</DisplayName>
  </Owner>
  <AccessControlList>
    <Grant>
      <Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CanonicalUser">
        <ID>8a6925ce4adf588a4532142d3f74dd8c71fa124b1ddee97f21c32aa379004fef</ID>
        <DisplayName>mtd@amazon.com</DisplayName>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
  </AccessControlList>
</AccessControlPolicy>
BODY
      hash[:expects].should == 200
      hash[:headers]["Content-Type"].should == "application/json"      
      hash[:host].should == "bucket.s3.amazonaws.com"
      hash[:method].should == "PUT"
      hash[:path].should be_nil
      hash[:query].should == { "acl" => nil }
    end
  end
  
end
