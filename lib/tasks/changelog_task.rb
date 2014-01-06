require "rake"
require "rake/tasklib"

module Fog
  module Rake
    class ChangelogTask < ::Rake::TaskLib

      def initialize
        desc "Update the changelog since the last release"
        task(:changelog) do
          timestamp = Time.now.utc.strftime('%m/%d/%Y')
          sha = `git log | head -1`.split(' ').last
          changelog = ["#{Fog::VERSION} #{timestamp} #{sha}"]
          changelog << ('=' * changelog[0].length)
          changelog << ''

          github_repo_data = Fog::JSON.decode(Excon.get('https://api.github.com/repos/fog/fog', :headers => {'User-Agent' => 'geemus'}).body)
          data = github_repo_data.reject {|key, value| !['forks', 'open_issues', 'watchers'].include?(key)}
          github_collaborator_data = Fog::JSON.decode(Excon.get('https://api.github.com/repos/fog/fog/collaborators', :headers => {'User-Agent' => 'geemus'}).body)
          data['collaborators'] = github_collaborator_data.length
          rubygems_data = Fog::JSON.decode(Excon.get('https://rubygems.org/api/v1/gems/fog.json').body)
          data['downloads'] = rubygems_data['downloads']
          stats = []
          for key in data.keys.sort
            stats << "'#{key}' => #{data[key]}"
          end
          changelog << "Stats! { #{stats.join(', ')} }"
          changelog << ''

          last_sha = `cat changelog.txt | head -1`.split(' ').last
          shortlog = `git shortlog #{last_sha}..HEAD`
          changes = {}
          committers = {}
          for line in shortlog.split("\n")
            if line =~ /^\S/
              committer = line.split(' (', 2).first
              committers[committer] = 0
            elsif line =~ /^\s*((Merge.*)|(Release.*))?$/
              # skip empty lines, Merge and Release commits
            else
              unless line[-1..-1] == '.'
                line << '.'
              end
              line.lstrip!
              line.gsub!(/^\[([^\]]*)\] /, '')
              tag = $1 || 'misc'
              changes[tag] ||= []
              changes[tag] << (line << ' thanks ' << committer)
              committers[committer] += 1
            end
          end

          for committer, commits in committers.to_a.sort {|x,y| y[1] <=> x[1]}
            if [
              'Aaron Suggs',
              'Brian Hartsock',
              'Chris Roberts',
              'Christopher Oliver',
              'Daniel Reichert',
              'Decklin Foster',
              'Dylan Egan',
              'Erik Michaels-Ober',
              'geemus',
              'Henry Addison',
              'James Bence',
              'Kevin Menard',
              'Kyle Rames',
              'Lincoln Stoll',
              'Luqman Amjad',
              'Michael Zeng',
              'Mike Hagedorn',
              'Mike Pountney',
              'Nat Welch',
              'Nick Osborn',
              'nightshade427',
              'Patrick Debois',
              'Paul Thornthwaite',
              'Rodrigo Estebanez',
              'Rupak Ganguly',
              'Stepan G. Fedorov',
              'Wesley Beary'
            ].include?(committer)
            next
            end
            changelog << "MVP! #{committer}"
            changelog << ''
            break
          end

          for tag in changes.keys.sort
            changelog << ('[' << tag << ']')
            for commit in changes[tag]
              changelog << ('  ' << commit)
            end
            changelog << ''
          end

          old_changelog = File.read('changelog.txt')
          File.open('changelog.txt', 'w') do |file|
            file.write(changelog.join("\n"))
            file.write("\n\n")
            file.write(old_changelog)
          end
        end
      end
    end
  end
end
