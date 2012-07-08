require 'forwardable'

module Madrox
  # Represents an author of a Madrox::Entry.
  class Actor
    extend Forwardable
    def_delegators :@actor,
      # Public: Returns the String name of the Actor.
      :name,

      # Public: Returns the String email address of the Actor.
      :email,

      # Public: Returns the String representation for an Actor in a Git
      # commit.
      :output

    # Public: Initializes with a Grit::Actor.
    #
    # actor - Grit::Actor.
    def initialize(actor)
      @actor = actor
    end
  end

  # Represents a single entry in a Madrox::Timeline.
  class Entry
    # Public: Wraps some Grit::Commit objects in Madrox::Entry objects.
    #
    # commits - Array of Grit::Commit objects.
    #
    # Returns an Array of Madrox::Entry objects.
    def self.from(commits)
      commits.map { |c| new(c) }
    end

    extend Forwardable
    def_delegators :@commit,
      # Public: Returns the String content of the Entry.
      :message,

      # Public: Returns the String unique SHA of the Entry.
      :sha,

      # Public: Returns the Time that the Entry was created.
      :authored_date

    # Public: Initializes from a Grit::Commit.
    #
    # commit - Grit::Commit.
    def initialize(commit)
      @commit = commit
    end

    # Public: Gets the original author of this Entry.  In retweets or favorites,
    # this is the author of the original Entry.
    #
    # Returns a Madrox::Actor.
    def author
      @actor ||= Actor.new(@commit.author)
    end

    # Public: Gets the committer of this Entry.  In retweets or favorites, this
    # is the author in the current timeline.
    #
    # Returns a Madrox::Actor.
    def committer
      @committer ||= Actor.new(@commit.committer)
    end
  end
end
