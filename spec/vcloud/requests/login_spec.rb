require 'spec_helper'

describe Fog::Vcloud, :type => :vcloud_request do
  subject { @vcloud }

  it_should_behave_like "all login requests"
end

