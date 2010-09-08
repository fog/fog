require File.dirname(__FILE__) + '/../spec_helper'

class FogAttributeTestModel < Fog::Model
  attribute :key_id, :aliases => "key", :squash => "id"
end

describe 'Fog::Attributes' do

  describe ".attribute" do
    describe "squashing a value" do
      it "should accept squashed key as symbol" do
        data = {"key" => {:id => "value"}}
        model = FogAttributeTestModel.new
        model.merge_attributes(data)
        model.key_id.should == "value"
      end

      it "should accept squashed key as string" do
        data = {"key" => {"id" => "value"}}
        model = FogAttributeTestModel.new
        model.merge_attributes(data)
        model.key_id.should == "value"
      end
    end

  end

end