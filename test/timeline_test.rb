require File.join(File.dirname(__FILE__), 'helper')

class TimelineTest < MadroxTest
  def setup
    teardown
    @repo = Madrox::Repo.new(File.join(File.dirname(__FILE__), 'fixtures/simple.git'))
  end

  def teardown
    clear_git_fixtures
  end

  def test_finds_messages
    messages = @repo.timeline('merged').messages
    assert_equal 3, messages.size
    assert_equal %w(
      f524dcedce5d4f20f3a1d2ecb79f63c8d175d85f 
      e28333e7c6f42004d7d619a1b485072e6361da94 
      cd45ac1b461450245fc104aea0506da6fab1db72), messages.map { |m| m.sha }
  end

  def test_posts_commit
    @repo = fork_git_fixture(:simple)
    timeline = @repo.timeline('user2', 'user2@email.com')
    assert_equal %w(e28333e7c6f42004d7d619a1b485072e6361da94), 
      timeline.messages.map { |m| m.sha }
    sha = timeline.post('hiya')
    assert_equal [sha, 'e28333e7c6f42004d7d619a1b485072e6361da94'], 
      timeline.messages.map { |m| m.sha }
  end

  def test_posts_commit_from_date
    @repo    = fork_git_fixture(:simple)
    timeline = @repo.timeline('user2', 'user2@email.com')
    sha      = timeline.post('hi', :committed_date => Time.utc(2000, 2))
    commit   = @repo.grit.commit(sha)
    assert_equal 2000, commit.committed_date.year
  end

  def test_retweets_without_annotation
    @repo     = fork_git_fixture(:simple)
    timeline1 = @repo.timeline('user1')
    timeline2 = @repo.timeline('user2')
    original  = timeline1.messages.last
    sha       = timeline2.retweet(original, :committed_date => Time.utc(2000, 2))
    retweet   = @repo.grit.commit(sha)
    assert_equal 1287750442,       retweet.authored_date.to_i
    assert_equal 2000,             retweet.committed_date.year
    assert_equal 'user1',          retweet.author.name
    assert_equal 'user2',          retweet.committer.name
    assert_equal original.message, retweet.message
  end

  def test_retweets_with_annotation
    @repo     = fork_git_fixture(:simple)
    timeline1 = @repo.timeline('user1')
    timeline2 = @repo.timeline('user2')
    original  = timeline1.messages.last
    sha       = timeline2.retweet(original, 'sweet!', :committed_date => Time.utc(2000, 2))
    retweet   = @repo.grit.commit(sha)
    assert_equal 1287750442, retweet.authored_date.to_i
    assert_equal 2000,       retweet.committed_date.year
    assert_equal 'user1',    retweet.author.name
    assert_equal 'user2',    retweet.committer.name
    assert_equal "sweet! RT @user1 #{original.message}", retweet.message
  end

  def test_favoriting_a_tweet
    @repo     = fork_git_fixture(:simple)
    timeline1 = @repo.timeline('user1')
    timeline2 = @repo.timeline('user2')
    original  = timeline2.messages.last

    assert_nil @repo.grit.commit('user1-favorites')
    sha  = timeline1.fave(original)
    fave = @repo.grit.commit(sha)
    assert_equal 'user1', fave.committer.name
    assert_equal 'user2', fave.author.name

    assert_equal sha, @repo.grit.commit('user1-favorites').sha
  end
end