require "rake"
require "rake/tasklib"

module Fog
  module Rake
    class ChangelogTask < ::Rake::TaskLib
      def initialize
        desc "Update the changelog since the last release"
        task(:changelog) do

          @changelog = []
          @changelog << release_header

          process_commits

          @changelog << "**MVP!** #{mvp}" if mvp
          @changelog << blank_line

          add_commits_to_changelog
          save_changelog
        end
      end

      private

      def release_header
        <<-HEREDOC
## #{Fog::VERSION} #{timestamp}
*Hash* #{sha}

Statistic     | Value
------------- | --------:
Collaborators | #{collaborators}
Forks         | #{forks}
Open Issues   | #{open_issues}
Watchers      | #{watchers}
        HEREDOC
      end

      def save_changelog
        old_changelog = File.read('CHANGELOG.md')
        File.open('CHANGELOG.md', 'w') do |file|
          file.write(@changelog.join("\n"))
          file.write("\n\n")
          file.write(old_changelog)
        end
      end

      def blank_line
        ''
      end

      def add_commits_to_changelog
        @changes.keys.sort.each do |tag|
          @changelog << "#### [#{tag}]"
          @changes[tag].each do |commit|
            @changelog << "*   #{commit}"
          end
          @changelog << blank_line
        end
      end

      def process_commits
        shortlog = `git shortlog #{last_release_sha}..HEAD`
        @changes = {}
        @committers = {}
        @committer = nil
        shortlog.split("\n").each do |line|
          @current_line = line
          if committer_line?
            @committer = committer_match[1]
            add_committer
          elsif !release_merge_line?
            add_period_if_necessary
            @current_line.lstrip!
            add_commit_line
            increment_commits
          end
        end
      end

      def add_commit_line
        @current_line.gsub!(/^\[([^\]]*)\] /, '')
        tag = $1 || 'misc'
        @changes[tag] ||= []
        @changes[tag] << "#{@current_line} thanks #{@committer}"
      end

      def increment_commits
        @committers[@committer] += 1
      end

      def add_committer
        @committers[@committer] = 0
      end

      def committers_sorted_by_commits
        committer_pairs = @committers.to_a.sort {|x,y| y[1] <=> x[1]}
        committer_pairs.reject! {|pair| pair.last < 1 }
        committer_pairs.map {|pair| pair.first }
      end

      def former_mvp?(committer)
         [
           'Aaron Suggs',
           'ller', #"Achim Ledermüller" UTF-8 fail?
           'Ash Wilson',
           'Benson Kalahar',
           'Brian Hartsock',
           'bryanl',
           'Cherdancev Evgeni',
           'Chris Luo',
           'Chris Roberts',
           'Christopher Oliver',
           'Colin Hebert',
           'Daniel Aragao',
           'Daniel Reichert',
           'Darren Hague',
           'Decklin Foster',
           'Dylan Egan',
           'effeminate-batman',
           'Erik Michaels-Ober',
           'Frederick Cheung',
           'geemus',
           'Henry Addison',
           'James Bence',
           'Josef Stribny',
           'Kevin Menard',
           'Kevin Olbrich',
           'Kyle Rames',
           'Ladislav Smola',
           'Lincoln Stoll',
           'Luqman Amjad',
           'Michael Hale',
           'Michael Zeng',
           'Mike Hagedorn',
           'Mike Pountney',
           'Nat Welch',
           'Nick Osborn',
           'nightshade427',
           'Oleg Vivtash',
           'Patrick Debois',
           'Paul Thornthwaite',
           'Paulo Henrique Lopes Ribeiro',
           'Peter Souter',
           'Phil Ross',
           'Rich Daley',
           'Rodrigo Estebanez',
           'Rupak Ganguly',
           'Stepan G. Fedorov',
           'swamp09',
           'TerryHowe',
           'Tinguely Pierre',
           'Wesley Beary'
         ].include?(committer)
      end

      def mvp
        return @mvp if @mvp
        committers_sorted_by_commits.each do |committer|
          unless former_mvp?(committer)
            @mvp = committer
            return @mvp
          end
        end
        nil
      end

      def add_period_if_necessary
        @current_line << "." unless @current_line[-1] == '.'
      end

      def release_merge_line?
        @current_line =~ /^\s*((Merge.*)|(Release.*))?$/
      end

      def committer_line?
        committer_match != nil
      end

      def committer_match
        @current_line.match (/([-\w\s]+)\s+\(\d+\)/)
      end

      def last_release_sha
        `cat CHANGELOG.md | head -2`.split(' ').last
      end

      def downloads
        response = Excon.get('https://rubygems.org/api/v1/downloads/fog.json')
        data = Fog::JSON.decode(response.body)
        data['total_downloads']
      end

      def collaborators
        response = Excon.get('https://api.github.com/repos/fog/fog/collaborators', :headers => {'User-Agent' => 'geemus'})
        data = Fog::JSON.decode(response.body)
        data.length
      end

      def forks
        repo_metadata['forks']
      end

      def open_issues
        repo_metadata['open_issues']
      end

      def watchers
        repo_metadata['watchers']
      end

      def repo_metadata
        return @repo_metadata if @repo_metadata
        response = Excon.get('https://api.github.com/repos/fog/fog', :headers => {'User-Agent' => 'geemus'})
        data = Fog::JSON.decode(response.body)
        @repo_metadata = data.select {|key, value| ['forks', 'open_issues', 'watchers'].include?(key)}
      end

      def sha
        `git log | head -1`.split(' ').last
      end

      def timestamp
        @time ||= Time.now.utc.strftime('%m/%d/%Y')
      end
    end
  end
end
