# external core dependencies
require 'base64'
require 'cgi'
require 'uri'
require 'excon'
require 'fileutils'
require 'formatador'
require 'openssl'
require 'time'
require 'timeout'
require 'ipaddr'

# internal core dependencies
require "fog/version"
require 'fog/core/attributes'
require 'fog/core/collection'
require 'fog/core/connection'
require 'fog/core/credentials'
require 'fog/core/current_machine'
require 'fog/core/deprecation'
require 'fog/core/errors'
require 'fog/core/hmac'
require 'fog/core/logger'
require 'fog/core/model'
require 'fog/core/mock'
require 'fog/core/provider'
require 'fog/core/service'
require 'fog/core/ssh'
require 'fog/core/scp'
require 'fog/core/time'
require 'fog/core/wait_for'
require 'fog/core/wait_for_defaults'
require 'fog/core/class_from_string'
require 'fog/core/uuid'

# data exchange specific (to be extracted and used on a per provider basis)
require 'fog/xml'
require 'fog/json'

# deprecation wrappers
require 'fog/core/deprecated/connection'

# service wrappers
require 'fog/compute'
require 'fog/identity'
require 'fog/image'
require 'fog/volume'
require 'fog/cdn'
require 'fog/dns'
require 'fog/network'
require 'fog/storage'
require 'fog/orchestration'
