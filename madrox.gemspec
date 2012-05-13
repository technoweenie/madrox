## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'madrox'
  s.version           = '0.3.0'
  s.date              = '2012-05-13'
  s.rubyforge_project = 'madrox'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "Distributed Twitter implementation on Git."
  s.description = "Distributed Twitter implementation on Git."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Rick Olson"]
  s.email    = 'technoweenie@gmail.com'
  s.homepage = 'http://github.com/technoweenie/madrox'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## If your gem includes any executables, list them here.
  s.executables = ["madrox"]
  s.default_executable = 'madrox'

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('yajl-ruby', ["~> 0.7.7"])
  s.add_dependency('grit', ["~> 2.5.0"])

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  #s.add_development_dependency('DEVDEPNAME', [">= 1.1.0", "< 2.0.0"])

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    LICENSE
    README.md
    Rakefile
    bin/madrox
    lib/madrox.rb
    lib/madrox/repo.rb
    lib/madrox/timeline.rb
    madrox.gemspec
    test/fixtures/empty.git/COMMIT_EDITMSG
    test/fixtures/empty.git/HEAD
    test/fixtures/empty.git/config
    test/fixtures/empty.git/description
    test/fixtures/empty.git/hooks/applypatch-msg.sample
    test/fixtures/empty.git/hooks/commit-msg.sample
    test/fixtures/empty.git/hooks/post-commit.sample
    test/fixtures/empty.git/hooks/post-receive.sample
    test/fixtures/empty.git/hooks/post-update.sample
    test/fixtures/empty.git/hooks/pre-applypatch.sample
    test/fixtures/empty.git/hooks/pre-commit.sample
    test/fixtures/empty.git/hooks/pre-rebase.sample
    test/fixtures/empty.git/hooks/prepare-commit-msg.sample
    test/fixtures/empty.git/hooks/update.sample
    test/fixtures/empty.git/index
    test/fixtures/empty.git/info/exclude
    test/fixtures/empty.git/logs/HEAD
    test/fixtures/empty.git/logs/refs/heads/master
    test/fixtures/empty.git/objects/54/3b9bebdc6bd5c4b22136034a95dd097a57d3dd
    test/fixtures/empty.git/objects/bc/bcd41f106f5124b1c12b272957518ac5565268
    test/fixtures/empty.git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391
    test/fixtures/empty.git/refs/heads/master
    test/fixtures/simple.git/COMMIT_EDITMSG
    test/fixtures/simple.git/HEAD
    test/fixtures/simple.git/ORIG_HEAD
    test/fixtures/simple.git/config
    test/fixtures/simple.git/description
    test/fixtures/simple.git/hooks/applypatch-msg.sample
    test/fixtures/simple.git/hooks/commit-msg.sample
    test/fixtures/simple.git/hooks/post-commit.sample
    test/fixtures/simple.git/hooks/post-receive.sample
    test/fixtures/simple.git/hooks/post-update.sample
    test/fixtures/simple.git/hooks/pre-applypatch.sample
    test/fixtures/simple.git/hooks/pre-commit.sample
    test/fixtures/simple.git/hooks/pre-rebase.sample
    test/fixtures/simple.git/hooks/prepare-commit-msg.sample
    test/fixtures/simple.git/hooks/update.sample
    test/fixtures/simple.git/index
    test/fixtures/simple.git/info/exclude
    test/fixtures/simple.git/logs/HEAD
    test/fixtures/simple.git/logs/refs/heads/master
    test/fixtures/simple.git/logs/refs/heads/merged
    test/fixtures/simple.git/logs/refs/heads/user1
    test/fixtures/simple.git/logs/refs/heads/user2
    test/fixtures/simple.git/objects/54/3b9bebdc6bd5c4b22136034a95dd097a57d3dd
    test/fixtures/simple.git/objects/90/1f323ae58b3f09043522db6dfe6131941b1393
    test/fixtures/simple.git/objects/bc/bcd41f106f5124b1c12b272957518ac5565268
    test/fixtures/simple.git/objects/cd/45ac1b461450245fc104aea0506da6fab1db72
    test/fixtures/simple.git/objects/e2/8333e7c6f42004d7d619a1b485072e6361da94
    test/fixtures/simple.git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391
    test/fixtures/simple.git/objects/f5/24dcedce5d4f20f3a1d2ecb79f63c8d175d85f
    test/fixtures/simple.git/packed-refs
    test/fixtures/simple.git/refs/heads/master
    test/fixtures/simple.git/refs/heads/merged
    test/fixtures/simple.git/refs/heads/user1
    test/fixtures/simple.git/refs/heads/user2
    test/fixtures/simple.git/refs/remotes/origin/HEAD
    test/helper.rb
    test/repo_test.rb
    test/timeline_test.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/.*_test\.rb/ }
end