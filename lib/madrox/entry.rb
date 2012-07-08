require 'forwardable'

module Madrox
  class Entry
    class Actor
      extend Forwardable
      def_delegators :@actor, :name, :email, :output

      def initialize(actor)
        @actor = actor
      end
    end

    def self.from(commits)
      commits.map { |c| new(c) }
    end

    extend Forwardable
    def_delegators :@commit, :message, :sha, :authored_date

    def initialize(commit)
      @commit = commit
    end

    def author
      @actor ||= Actor.new(@commit.author)
    end

    def committer
      @committer ||= Actor.new(@commit.committer)
    end
  end
end
