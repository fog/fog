require 'fog/core/model'

module Fog
  module Compute
    class VcloudDirector

      class CustomField < Model

        identity  :id
        attribute :value
        attribute :type
        attribute :password
        attribute :user_configurable

      end
    end
  end
end
