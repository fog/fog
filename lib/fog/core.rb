__LIB_DIR__ = File.expand_path(File.join(File.dirname(__FILE__), '..'))

$LOAD_PATH.unshift __LIB_DIR__ unless
  $LOAD_PATH.include?(__LIB_DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__LIB_DIR__))

# external core dependencies
require 'rubygems'
require 'base64'
require 'cgi'
require 'uri'
require 'excon'
require 'fileutils'
require 'formatador'
require 'time'
require 'timeout'

# internal core dependencies
require 'fog/core/attributes'
require 'fog/core/collection'
require 'fog/core/connection'
require 'fog/core/credentials'
require 'fog/core/deprecation'
require 'fog/core/errors'
require 'fog/core/hmac'
require 'fog/core/model'
require 'fog/core/mock'
# require 'fog/core/parser'
require 'fog/core/provider'
require 'fog/core/service'
require 'fog/core/ssh'
require 'fog/core/scp'
require 'fog/core/time'
require 'fog/core/timeout'
require 'fog/core/wait_for'
