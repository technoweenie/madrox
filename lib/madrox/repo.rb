module Madrox
  class Repo
    class << self
      attr_accessor :repo_class
    end

    # Public: Loads a Repo using the first available Git adapter.
    #
    # path - the String path of the Repository.
    #
    # Returns a Madrox::Repo subclass.
    def self.for(path)
      if repo_class
        repo_class.new(path)
      else
        with_grit(path)
      end
    end

    # Internal: Initializes a Madrox::Repo that uses Grit.
    #
    # path - The String path of the Repository.
    #
    # Returns a Madrox::GritRepo.
    def self.with_grit(path)
      Madrox.require_lib :grit_repo
      (self.repo_class = GritRepo).new(path)
    end

    def initialize(path)
      raise NotImplementedError
    end

    # Public: Gets a Madrox::Timeline for the given user.
    #
    # user  - String user name for the timeline.
    # email - Optional string email address for commit messages.
    #
    # Returns a Madrox::Timeline.
    def timeline(user, email = nil)
      Timeline.new(self, user, email)
    end

    # Public: Determines whether this Madrox repo has an available Git repo.
    #
    # Returns true if the Git repo exists, or false.
    def exist?
      raise NotImplementedError
    end

    # Internal: Gets themessages for this timeline.
    #
    # timeline - A Madrox::Timeline instance.
    # struct   - A Madrox::MessagesOptions instance.
    #
    # Returns an Array of Madrox::Entry objects.
    def messages(timeline, struct)
      raise NotImplementedError
    end

    # Internal: Creates a new Madrox::Entry.
    #
    # timeline - A Madrox::Timeline instance.
    # message  - The String content of the entry.
    # struct   - A Madrox::PostOptions instance.
    #
    # Returns a String of the created Git SHA.
    def post(timeline, message, struct)
      raise NotImplementedError
    end
  end
end

