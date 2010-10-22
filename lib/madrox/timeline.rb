module Madrox
  class Timeline
    # Public: Gets the user name for this timeline.
    #
    # Returns a String.
    attr_reader :user

    # Public: Gets the email for this timeline.  This is used as part of the
    # git actor when posting updates.
    #
    # Returns a String.
    attr_reader :email

    # Public: Sets the email for this timeline.
    #
    # email - The String email.
    # 
    # Returns nothing.
    attr_accessor :email

    # Gets the Madrox object for this timeline.
    #
    # Returns a Madrox::Repo instance.
    attr_reader   :repo

    # Gets the Grit object for this Madrox::Repo.
    #
    # Returns a Grit::Repo instance.
    attr_reader   :grit

    def initialize(repo, user, email = nil)
      @user  = user
      @email = email
      @repo  = repo
      @grit  = repo.grit
    end

    # Public: Gets the messages for this timeline.  Automatically removes any 
    # merge commits.
    #
    # Returns an Array of Grit::Commit instances.
    def messages
      @grit.log(@user).delete_if { |commit| commit.parents.size != 1 }
    end

    # Posts the given message to the timeline.  This is a simple commit with
    # no changed content.  Just a message.
    #
    # message - String message for the timeline update.
    # options - Hash of options passed to Grit::Index#commit. 
    #
    # Returns a String SHA1 of the created Git commit.
    def post(message, options = {})
      idx     = @grit.index
      parents = [@grit.commit(@user) || @grit.commit("HEAD")]
      parents.compact!
      options.update(:parents => parents, :committer => actor, :head => @user)
      @grit.index.commit(message, options)
    end

    # Retweets a given commit.  The author name and date is taken from the 
    # commit.  The message can optionally be annotated.
    #
    # commit  - The Grit::Commit that is being retweeted.
    # message - An optional String annotation to the retweet content.
    # options - An optional Hash that is passed to #post.
    #
    # Returns a String SHA1 of the created Git commit.
    def retweet(commit, message, options = {})
      if message.is_a?(Hash)
        options = message
        message = nil
      end
      if message
        message << " RT @#{commit.author.name}"
      end
      message = "#{message} #{commit.message}"
      message.strip!
      post(message, options.update(:author => commit.author, 
        :authored_date => commit.authored_date))
    end

    # Public: Builds a Git actor object for any posted updates to this 
    # timeline.  Uses the timelines user and email.
    #
    # Returns a Grit::Actor.
    def actor
      Grit::Actor.new(@user, @email)
    end
  end
end