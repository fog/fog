require 'ecloud/spec_helper'

describe 'Ecloud' do

  it do
    pending unless Ecloud.available?
    Ecloud.should have_at_least(1).services
  end

  describe "when indexing it like an array" do


    describe "with a service that exists" do
      it "should return something when indexed with a configured service" do
        pending unless Ecloud.available?
        Fog::Compute[:ecloud].should_not be_nil
      end
    end

    describe "with a service that does not exist" do
      it "should raise an ArgumentError" do
        pending unless Ecloud.available?
        lambda {Ecloud[:foozle]}.should raise_error(ArgumentError)
      end
    end

  end
end
