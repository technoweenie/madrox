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
end