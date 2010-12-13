# Madrox

Distributed Twitter implementation built on Git using content-less commits as
tweets.

## USAGE

Madrox needs an existing repository with at a single initial commit.  "Tweets"
are simply commits in a user-specific branch.  Use git to push/pull these 
branches with remote git repositories.  Create custom timelines by merging
them locally.

    $ cd madrox-sample
    $ git init
    $ touch README
    $ git add README
    $ git commit -m "initial"

    $ madrox rick --email=rick@whatever.com --msg="Hi"
    @rick: Hi
    8578cec211388123e071eccb1fda2024a44ac4c5

    $ madrox bob --email=bob@whatever.com --msg="@rick: sup?"
    @bob: @rick: sup?
    002e1e01517ef2e5486b696814146d5cca4c07a2

    $ madrox rick --email=rick@whatever.com --msg="@bob: nada"
    @rick: @bob: nada
    178f84a58ab1878d1a995ba9ce16ad11e5e58808

Now, we have three tweets from two different users in their own branch.  You
can merge these two branches into a single branch to see their commits in one
stream:

    $ git branch
      bob
    * master
      rick

    # Create a new branch
    $ git checkout -b timeline
    $ git merge rick
    $ git merge bob

    $ madrox rick
    @rick: @bob: nada
    @rick: Hi

    $ madrox timeline
    @rick: @bob: nada
    @bob: @rick: sup?
    @rick: Hi

## Importing

You can import tweets with the `--import` option.  You're still bound by Twitter's 3200 tweet limit, unfortunately.

    $ madrox --import=twitter --since-id=123 --max-id=456 --email=EMAIL TWITTER_LOGIN

    You can also use `rake console` and import the data yourself from other sources.

    $ madrox --irb --email=EMAIL TWITTER_LOGIN
    >> tweets.each do |tweet|
    ?>   timeline.post(tweet['text'], :committed_date => Time.parse(tweet['created_at']))
    ?> end

## Ruby API

The Madrox ruby API revolves around two objects:  `Madrox::Repo` and 
`Madrox::Timeline`.

`Madrox::Repo` simply tracks the Git repo.  It's used to create Timeline
instances.

    repo = Madrox::Repo.new "/path/to/repo"
    timeline = repo.timeline('rick', 'rick@email.com')

`Madrox::Timeline` represents a branch of the Git repo, and lets you post
new messages to it.  These branches can either represent a user's timeline,
a grouped timeline with commits merged from multiple users, or something 
custom (such as a user's favorites).

    timeline.post("Eating a sandwich.")

You can list messages from a timeline.  They come out as `Grit::Commit` 
instances.

    mine = repo.timeline('me', 'my-email@email.com')
    rick = repo.timeline('rick')
    msg = rick.messages.first
    msg.sha            # => 21f1ca7995b46a1008c402c92c4aa074806f92c4
    msg.message        # => "Eating a sandwich."
    msg.committer      # => #<Grit::Actor "rick ...">
    msg.committed_date # => Sat Nov 6 11:48:02 -0700 2010

You can add a message as a favorite:

    sha = mine.fave(msg)
    commit = mine.grit.commit(sha)
    commit.sha            # => b1dfaf30dff279b953abc8b985bb41e247a0e50c
    commit.message        # => "Eating a sandwich."
    commit.committer      # => #<Grit::Actor "me ...">
    commit.committed_date # => Sat Nov 6 12:48:02 -0700 2010
    commit.author         # => #<Grit::Actor "rick ...">
    commit.authored_date  # => Sat Nov 6 11:48:02 -0700 2010

You can also retweet the message:

    sha = mine.retweet(msg)
    commit = mine.grit.commit(sha)
    commit.sha            # => d1d22036741d0726901b8e555801885018e7c8df
    commit.message        # => "Eating a sandwich."
    commit.committer      # => #<Grit::Actor "me ...">
    commit.committed_date # => Sat Nov 6 12:48:02 -0700 2010
    commit.author         # => #<Grit::Actor "rick ...">
    commit.authored_date  # => Sat Nov 6 11:48:02 -0700 2010

Add your own snarky comment:

    sha = mine.retweet(msg, "TMI, bro!")
    commit = mine.grit.commit(sha)
    commit.sha            # => 06836ee40595bf06fde3eb276a08b10ac7733a74
    commit.message        # => "TMI, bro! RT @rick Eating a sandwich."

## TODO

* Twitter pushing support
* Git Notes for Twitter (or other) metadata.
* Better importing.
