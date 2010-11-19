#puts $:
#puts File.exist?('fog/core/version_helper.rb')
#
#puts require 'fog/core/version_helper.rb' #unless defined?(::Fog::VersionHelper)

module Fog


  class Bdd

    def self.fog_library_dir
      File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end

    def self.core_dir
      File.join(self.fog_library_dir, 'core')
    end

    def self.version_helper
      ::Fog::VersionHelper.new(self.core_dir)
    rescue => detail
      puts "Error in initialising VersionHelper class"
      puts detail.message
      puts detail.backtrace.join('\n')
      raise
    end

  end

end