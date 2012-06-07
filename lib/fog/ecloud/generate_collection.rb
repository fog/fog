require 'optparse'

class String
  def camelize
    self.split('_').map {|w| w.capitalize}.join
  end
end


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"
  opts.on("-m", "--model-name NAME", "Model Name") { |v| options[:model] = v }
  opts.on("-c", "--collection-name NAME", "Collection Name") { |v| options[:collection] = v }
  opts.on("-M", "--methods a:href,b:href,c:href", Array, "List of methods to be defined and href to the method") { |v| options[:methods] = v.map { |a| a.split(':') } }
  opts.on("-a", "--attributes name:alias,other_name:other_alias", Array, "List of attributes to be defined") { |v| options[:attributes] = v.map { |a| a.split(':') } }
end.parse!

if options[:methods]
  methods = options[:methods].map do |m|
    m = <<METHOD
def #{m[0]}
          @#{m[0]} = Fog::Compute::Ecloud::#{m[0].camelize}.new(:connection => connection, :href => "#{m[1]}")
        end
METHOD
  end.join("\n        ")
end


if options[:attributes]
  attributes = options[:attributes].map do |a|
    a = "attribute :#{a[0]}, :aliases => :#{a[1] || a[0].camelize}"
  end.join("\n        ")
end

collection_file         = "#{File.expand_path(File.dirname(__FILE__))}/models/compute/#{options[:collection]}.rb"
model_file              = "#{File.expand_path(File.dirname(__FILE__))}/models/compute/#{options[:model]}.rb"
collection_request_file = "#{File.expand_path(File.dirname(__FILE__))}/requests/compute/get_#{options[:collection]}.rb"
model_request_file      = "#{File.expand_path(File.dirname(__FILE__))}/requests/compute/get_#{options[:model]}.rb"

collection = <<COLLECTION
require 'fog/ecloud/models/compute/#{options[:model]}'

module Fog
  module Compute
    class Ecloud
      class #{options[:collection].camelize} < Fog::Ecloud::Collection

        identity :href

        model Fog::Compute::Ecloud::#{options[:model].camelize}

        def all
          data = connection.get_#{options[:collection]}(href).body
          load(data)
        end

        def get(uri)
          if data = connection.get_#{options[:model]}(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
COLLECTION

model = <<MODEL
module Fog
  module Compute
    class Ecloud
      class #{options[:model].camelize} < Fog::Model
        identity :href

        #{attributes}

        #{methods}
        def id
          href.scan(/\\d+/)[0]
        end
      end
    end
  end
end
MODEL

collection_request = <<COLLECTION
module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_#{options[:collection]}
      end

      class Mock
        def get_#{options[:collection]}(uri)
        end
      end
    end
  end
end
COLLECTION

model_request = <<MODEL
module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_#{options[:model]}
      end

      class Mock
        def get_#{options[:model]}(uri)
        end
      end
    end
  end
end
MODEL


File.open(collection_file, 'w') { |f| f.write(collection) }
File.open(model_file, 'w') { |f| f.write(model) }
File.open(collection_request_file, 'w') { |f| f.write(collection_request) }
File.open(model_request_file, 'w') { |f| f.write(model_request) }
