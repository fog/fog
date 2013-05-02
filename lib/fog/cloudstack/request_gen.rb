require 'nokogiri'
require 'open-uri'
require 'optparse'

Options = Hash.new

def decamelize(str)
  str.gsub(/(^|[a-z])([A-Z])/) do
    ($1.empty?)? $2 : "#{$1}_#{$2}"
  end.downcase
end
 
def generate_from_api(url)
  command = url.split('/').pop.sub('.html', '')
  method_name = decamelize command
   
  doc = Nokogiri::HTML(open(url))
  method_description_xpath = '//*[@id="main_content"]/div/div/div[1]/div[1]/p[2]'
  method_description = doc.xpath(method_description_xpath).text

  File.write "requests/compute/#{method_name}.rb", <<-compute_request_template
  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # #{method_description}
          #
          # {CloudStack API Reference}[#{url}]
          def #{method_name}(options={})
            options.merge!(
              'command' => '#{command}'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
  compute_request_template

  open('command_list.out', 'a') { |f|
    f.puts "request :#{method_name}"
  }
 
end

def find_api_links(url)
  doc = Nokogiri::HTML(open(url))
  url = url.sub!(/\/\w+\.html$/, '')

  result = doc.xpath('//a[starts-with(@href, "root")]').map{ |a| [a['href'], a.text] }
  result.each do |val, index|
    generate_from_api("#{url}/#{val}")
  end
end

def parse_full_setup_args
  ARGV.options do |opts|
    opts.banner = "Usage: request_gen.rb [options]"

    opts.on("--url STR", "Cloudstack API doc url.") do |val|
      Options['url'] = val
    end

    opts.on_tail("-h", "--help", "--usage", "Usage information.") do |setting|
      puts opts.help
      exit
    end

  end.parse!
end

parse_full_setup_args

valid = true
if !Options.has_key?('url')
  puts "Missing required argument API url"
  valid = false
end

if !valid
  puts "Run request_gen --help for more info"
  exit
end

find_api_links(Options['url'])

puts "Finished creating API request for #{Options['url']}"

