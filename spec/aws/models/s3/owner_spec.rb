require File.dirname(__FILE__) + '/../../../spec_helper'

describe 'Fog::AWS::S3::Owner' do

  describe "#initialize" do

    it "should remap attributes from parser" do
      owner = Fog::AWS::S3::Owner.new(
        'DisplayName' => 'name',
        'ID'          => 'id'
      )
      owner.display_name.should == 'name'
      owner.id.should == 'id'
    end

  end

end
