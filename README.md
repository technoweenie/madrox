# Madrox

Distributed Twitter implementation built on Git using content-less commits as
tweets.

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

## Requirements

gem install grit