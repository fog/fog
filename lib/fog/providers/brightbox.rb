require File.join(File.dirname(__FILE__), '..', 'core')

module Fog
  module Brightbox
    extend Fog::Provider

    service(:compute, 'compute/brightbox')
  end
end
