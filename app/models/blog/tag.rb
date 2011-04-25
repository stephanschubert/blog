module Blog
  class Tag
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Slug

    field :name, type: String
    validates_presence_of :name
    slug :name

  end
end
