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
    attr_reader :repo

    # Gets the Grit object for this Madrox::Repo.
    #
    # Returns a Grit::Repo instance.
    attr_reader :grit

    def initialize(repo, user, email = nil)
      @user  = user
      @email = email
      @repo  = repo
      @grit  = repo.grit
    end

    # Public: Gets the messages for this timeline.  Automatically removes any
    # merge commits.
    #
    # options - Hash of options to filter the message output.
    #           :max_count - Fixnum specifying the number of commits to show.
    #                        Default: 30.
    #           :skip      - Fixnum specifying the number of commits to skip.
    #           :page      - Fixnum of the current page.  This is used to
    #                        implicitly calculate the :skip option.
    #                        Default: 1
    #
    # Returns an Array of Grit::Commit instances.
    def messages(options = {})
      options[:no_merges]   = true
      options[:max_count] ||= 30
      options[:skip]      ||= begin
        options[:max_count] * ([options.delete(:page).to_i, 1].max - 1)
      end
      Entry.from(@grit.log(@user, nil, options).
        delete_if { |commit| commit.parents.size != 1 })
    end

    # Public: Posts the given message to the timeline.  This is a simple
    # commit with no changed content.  Just a message.
    #
    # message - String message for the timeline update.
    # options - Hash of options passed to Grit::Index#commit.
    #           :committed_date - The Time that the Entry was written.
    #           :author         - The Madrox::Entry::Actor of the original
    #                             author (if different than the committer).
    #           :authored_date  - The Time that the original Entry was written.
    #           :head           - The String name of the Git reference to
    #                             update.  Defaults to the 
    #           :parent         - The String SHA of the parent commit.  Defaults
    #                             to the current SHA of the 
    #
    # Returns a String SHA1 of the created Git commit.
    def post(message, options = {})
      idx = @grit.index
      options = {:committer => actor, :head => @user}.update(options)
      options[:parents] ||= begin
        parent = options[:parent] || @grit.commit(options[:head]) ||
          @grit.commit("HEAD")
        [parent]
      end
      options[:parents].compact!
      @grit.index.commit(message, options)
    end

    # Public: Retweets a given commit.  The author name and date is taken
    # from the commit.  The message can optionally be annotated.
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

    # Public: Marks a given commit as a favorite.  The commit is stored in a
    # separate branch named "#{user}-favorites".  The commit's original
    # committed author and date remain the same, and the new commit tracks
    # the date it was favorited.
    def fave(commit)
      post(commit.message, :head => "#{@user}-favorites",
        :author => commit.author, :authored_date => commit.authored_date)
    end

    # Public: Builds a Git actor object for any posted updates to this 
    # timeline.  Uses the timelines user and email.
    #
    # Returns a Grit::Actor.
    def actor
      Entry::Actor.new(Grit::Actor.new(@user, @email))
    end
  end
end
