module Blog
  class Tag
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Slug

    field :name, type: String
    validates_presence_of :name
    slug :name

    #has_and_belongs_to_many :posts
    embedded_in :post

    cattr_accessor :separator
    self.separator = ','

    # Returns all unique (the name counts) tags embedded in posts.
    # TODO * Speed up.
    #      * Ensure the first tag w/ a name is used because of slug
    #        generation for the subsequent ones.

    def self.all
      Post.only(:tags).map(&:tags).flatten.inject({}) { |uniq, tag|
        uniq[tag.name] ||= tag
        uniq
      }.values
    end
  end
end
