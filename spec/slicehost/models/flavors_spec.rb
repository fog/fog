require File.dirname(__FILE__) + '/../../../spec_helper'
require File.dirname(__FILE__) + '/../../../shared_examples/flavors_examples'

describe 'Fog::AWS::Slicehost::Flavors' do

  it_should_behave_like "Flavors"

  subject { @flavor = @flavors.all.first }

  before(:each) do
    @flavors = Slicehost[:slices].flavors
  end

end