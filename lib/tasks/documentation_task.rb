require "rake"
require "rake/tasklib"

module Fog
  module Rake
    class DocumentationTask < ::Rake::TaskLib
      def initialize
        task :docs do
          Rake::Task[:supported_services_docs].invoke
          Rake::Task[:upload_fog_io].invoke
          Rake::Task[:upload_yardoc].invoke

          # connect to storage provider
          Fog.credential = :geemus
          storage = Fog::Storage.new(:provider => 'AWS')
          directory = storage.directories.new(:key => 'fog.io')
          # write base index with redirect to new version
          directory.files.create(
            :body         => redirecter('latest'),
            :content_type => 'text/html',
            :key          => 'index.html',
            :public       => true
          )

          Formatador.display_line
        end

        task :supported_services_docs do
          support, shared = {}, []
          for key, values in Fog.services
            unless values.length == 1
              shared |= [key]
              values.each do |value|
                support[value] ||= {}
                support[value][key] = '+'
              end
            else
              value = values.first
              support[value] ||= {}
              support[value][:other] ||= []
              support[value][:other] << key
            end
          end
          shared.sort! {|x,y| x.to_s <=> y.to_s}
          columns = [:provider] + shared + [:other]
          data = []
          for key in support.keys.sort {|x,y| x.to_s <=> y.to_s}
            data << { :provider => key }.merge!(support[key])
          end

          table = ''
          table << "<table border='1'>\n"

          table << "  <tr>"
          for column in columns
            table << "<th>#{column}</th>"
          end
          table << "</tr>\n"

          for datum in data
            table << "  <tr>"
            for column in columns
              if value = datum[column]
                case value
                when Array
                  table << "<td>#{value.join(', ')}</td>"
                when '+'
                  table << "<td style='text-align: center;'>#{value}</td>"
                else
                  table << "<th>#{value}</th>"
                end
              else
                table << "<td></td>"
              end
            end
            table << "</tr>\n"
          end

          table << "</table>\n"

          File.open('docs/about/supported_services.markdown', 'w') do |file|
            file.puts <<-METADATA
---
layout: default
title:  Supported Services
---

            METADATA
            file.puts(table)
          end
        end

        desc "Builds the fog.io site content locally"
        task :build_fog_io do
          sh "jekyll docs docs/_site"
        end

        task :upload_fog_io => :build_fog_io do
          # connect to storage provider
          Fog.credential = :geemus
          storage = Fog::Storage.new(:provider => 'AWS')
          directory = storage.directories.new(:key => 'fog.io')

          # write web page files to versioned 'folder'
          for file_path in Dir.glob('docs/_site/**/*')
            next if File.directory?(file_path)
            file_name = file_path.gsub('docs/_site/', '')
            key = '' << version << '/' << file_name
            Formatador.redisplay(' ' * 128)
            Formatador.redisplay("Uploading [bold]#{key}[/]")
            if File.extname(file_name) == '.html'
              # rewrite links with version
              body = File.read(file_path)
              body.gsub!(/vX.Y.Z/, 'v' << version)
              body.gsub!(/='\//, %{='/} << version << '/')
              body.gsub!(/="\//, %{="/} << version << '/')
              content_type = 'text/html'
              directory.files.create(
                :body         => redirecter(key),
                :content_type => 'text/html',
                :key          => 'latest/' << file_name,
                :public       => true
              )
            else
              body = File.open(file_path)
              content_type = nil # leave it up to mime-types
            end
            directory.files.create(
              :body         => body,
              :content_type => content_type,
              :key          => key,
              :public       => true
            )
          end
          Formatador.redisplay(' ' * 128)
          Formatador.redisplay("Uploaded docs/_site\n")
        end

        def redirecter(path)
          redirecter = <<-HTML
<!doctype html>
<head>
<title>fog</title>
<meta http-equiv="REFRESH" content="0;url=http://fog.io/#{path}">
</head>
<body>
  <a href="http://fog.io/#{path}">redirecting to lastest (#{path})</a>
</body>
</html>
          HTML
        end
      end
    end
  end
end
