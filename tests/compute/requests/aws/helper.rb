class AWS

  module Compute

    module Formats

      BASIC = {
        'requestId' => String,
        'return'    => ::Fog::Boolean
      }

    end

  end

end

unless defined?(GENTOO_AMI)
  GENTOO_AMI = 'ami-5ee70037'
end
