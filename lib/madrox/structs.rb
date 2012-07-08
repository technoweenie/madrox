module Madrox
  # Internal: Common Option Struct methods.
  module StructMethods
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Internal: Initializes the option struct with the given optional Hash.
      #
      # hash - Either a Hash of key,value pairs, or nil.
      #
      # Returns the new Struct instance.
      def fill(hash)
        hash ? new.fill(hash) : new
      end
    end

    # Internal: Fills the struct with the given optional Hash.
    #
    #
    # hash - Either a Hash of key,value pairs, or nil.
    #
    # Returns this Struct instance.
    def fill(hash)
      hash.each_pair do |key, value|
        send "#{key}=", value
      end if hash
      self
    end
  end

  # Internal: Struct that represents the configurable options for listing
  # messages in a Timeline.
  class MessagesOptions < Struct.new(:max_count, :skip, :page, :no_merges)
    include StructMethods

    def page
      @page ||= [self[:page].to_i, 1].max
    end

    def skip
      @skip ||= (self[:skip] || max_count * (page - 1)).to_i
    end

    def max_count
      @max_count ||= (self[:max_count] || 30).to_i
    end

    def max_count=(value)
      @max_count = self[:max_count] = value.to_i
    end

    def skip=(value)
      @skip = self[:skip] = value.to_i
    end

    def to_options
      {:no_merges => true, :max_count => max_count, :skip => skip}
    end
  end

  # Internal: Struct that represents the configurable optoins for creating
  # new entries in a Timeline.
  class PostOptions < Struct.new(:head, :committer, :committed_date, :author, :authored_date, :parent)
    include StructMethods

    def to_options
      {:head => head, :parents => [parent],
       :committer => committer, :committed_date => committed_date,
       :author => author, :authored_date => authored_date}
    end
  end
end
