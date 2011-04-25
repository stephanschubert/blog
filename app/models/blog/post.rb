module Blog
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps

    field :title, type: String
    validates_presence_of :title

  end
end
