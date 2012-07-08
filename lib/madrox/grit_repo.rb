require 'grit' unless Object.const_defined?(:Grit)

module Madrox
  class GritRepo < Repo
    # Gets the Grit object for this Madrox::Repo.
    #
    # Returns a Grit::Repo instance.
    attr_reader :grit

    def initialize(path)
      @grit = Grit::Repo.new(path)
    rescue Grit::NoSuchPathError, Grit::InvalidGitRepositoryError
    end

    # Public: Determines whether this Madrox repo has an available Git repo.
    #
    # Returns true if the Git repo exists, or false.
    def exist?
      @grit && @grit.git.exists?
    end

    # Internal: Gets themessages for this timeline.
    #
    # timeline - A Madrox::Timeline instance.
    # struct   - A Madrox::MessagesOptions instance.
    #
    # Returns an Array of Madrox::Entry objects.
    def messages(timeline, struct)
      Entry.from(@grit.log(timeline.user, nil, struct.to_options).
        delete_if { |commit| commit.parents.size != 1 })
    end

    # Internal: Creates a new Madrox::Entry.
    #
    # timeline - A Madrox::Timeline instance.
    # message  - The String content of the entry.
    # struct   - A Madrox::PostOptions instance.
    #
    # Returns a String of the created Git SHA.
    def post(timeline, message, struct)
      @grit.index.commit(message, struct.to_options)
    end
  end
end

