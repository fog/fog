require 'fog/core/model'

module Fog
  module Compute
    class AWS

      class DhcpOption < Fog::Model

        identity  :id,                          :aliases => 'dhcpOptionsId'
        attribute :dhcp_configuration_set,      :aliases => 'dhcpConfigurationSet'
        attribute :tag_set,                     :aliases => 'tagSet'

        def initialize(attributes={})
          super
        end

        # Associates an existing dhcp configration set with a VPC
        #
        # dhcp_option.attach(dopt-id, vpc-id)
        #
        # ==== Returns
        #
        # True or false depending on the result
        #
        def associate(vpc_id)
          requires :id
          connection.attach_dhcp_option(id, vpc_id)
          #reload
        end

        # Removes an existing dhcp configuration set
        #
        # dhcp_option.destroy
        #
        # ==== Returns
        #
        # True or false depending on the result
        #

        def destroy
          requires :id
          connection.delete_dhcp_options(id)
          true
        end

        # Create a dhcp configuration set
        #
        #  >> g = AWS.dhcp_options.new()
        #  >> g.save
        #
        # == Returns:
        #
        # requestId and a dhcpOptions object
        #

        def save
          requires :dhcp_configuration_set
          data = connection.create_dhcp_options(dhcp_configuration_set).body['dhcpOptionsSet'].first
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          true

          true
        end
      end
    end
  end
end
