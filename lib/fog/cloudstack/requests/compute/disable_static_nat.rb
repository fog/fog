module Fog
  module Compute
    class Cloudstack

      class Real
        # Disables static rule for given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/disableStaticNat.html]
        def disable_static_nat(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'disableStaticNat') 
          else
            options.merge!('command' => 'disableStaticNat', 
            'ipaddressid' => args[0])
          end
          request(options)
        end
      end

      class Mock
        def disable_static_nat(*args)
          ip_address_id = args[0].is_a?(Hash) ? args[0]['ipaddressid'] : args[0]

          address = self.data[:public_ip_addresses][ip_address_id]

          unless address
            raise Fog::Compute::Cloudstack::BadRequest.new(
"Unable to execute API command disablestaticnat due to invalid value. \
Invalid parameter ipaddressid value=#{ip_address_id} due to incorrect long value format, \
or entity does not exist or due to incorrect parameter annotation for the field in api cmd class.")
          end

          if address['virtualmachineid'].nil?
            raise Fog::Compute::Cloudstack::BadRequest.new(
"Specified IP address id is not associated with any vm Id")
          end

          address.merge!(
            'virtualmachineid'          => nil,
            'virtualmachinname'         => nil,
            'virtualmachinedisplayname' => nil
          )
          {'enablestaticnatresponse' => {'success' => 'true'}}
        end
      end
    end
  end
end

