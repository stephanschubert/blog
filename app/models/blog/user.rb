module Blog
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :posts, class_name: "Blog::Post"

    field :name, type: String
    validates_presence_of :name

  end
end
