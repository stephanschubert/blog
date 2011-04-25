module Blog
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Slug

    field :title, type: String
    validates_presence_of :title
    slug :title

    field :body, type: String
    validates_presence_of :body

    field :published_at, type: DateTime

    has_and_belongs_to_many :tags

  end
end
