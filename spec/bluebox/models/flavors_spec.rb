require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../shared_examples/flavors_examples'

describe 'Fog::Bluebox::Flavors' do

  it_should_behave_like "Flavors"

  subject { @flavor = @flavors.all.first }

  before(:each) do
    @flavors = Bluebox[:blocks].flavors
  end

end
