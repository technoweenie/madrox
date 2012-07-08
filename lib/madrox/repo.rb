module Madrox
  class Repo
    # Gets the Grit object for this Madrox::Repo.
    #
    # Returns a Grit::Repo instance.
    attr_reader :grit

    def initialize(path)
      @grit = Grit::Repo.new(path)
    rescue Grit::NoSuchPathError, Grit::InvalidGitRepositoryError
    end

    # Public: Determines whether this Madrox repo has an available Git
    # repo.
    #
    # Returns true if the Git repo exists, or false.
    def exist?
      @grit && @grit.git.exists?
    end

    # Gets a Madrox::Timeline for the given user.
    #
    # user  - String user name for the timeline.
    # email - Optional string email address for commit messages.
    #
    # Returns a Madrox::Timeline.
    def timeline(user, email = nil)
      Timeline.new(self, user, email)
    end
  end
end
