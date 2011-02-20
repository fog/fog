require 'ecloud/spec_helper'

describe 'Ecloud' do
  it { Ecloud.should be_available }

  it { Ecloud.should have_at_least(1).services }

  describe "when indexing it like an array" do
    describe "with a service that exists" do
      it "should return something when indexed with a configured service" do
        Ecloud[:compute].should_not be_nil
      end
    end

    describe "with a service that does not exist" do
      it "should raise an ArgumentError" do
        lambda {Ecloud[:foozle]}.should raise_error(ArgumentError)
      end
    end

  end
end
