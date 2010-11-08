require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../shared_examples/flavors_examples'

describe 'Fog::Brightbox::Compute::Flavors' do

  if Fog.mocking?
    it "needs to have mocks implemented"
  else
    it_should_behave_like "Flavors"
  end

  subject { @flavor = @flavors.all.first }

  before(:each) do
    @flavors = Brightbox[:compute].flavors
  end

end
