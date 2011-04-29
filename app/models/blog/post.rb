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

    has_and_belongs_to_many :tags, :class_name => "Blog::Tag" do
      def to_s
        map(&:name).join(Blog::Tag.separator)
      end
    end

    named_scope :published, lambda { |before = Time.now, month = nil|
      if before.is_a?(Time)
        where(:published_at.lt => before.utc)
      else
        year = before

        if month
          from = Time.parse("#{year}/#{month}")
          till = from.end_of_month
        else
          from = Time.parse("#{year}/01")
          till = from.end_of_year
        end

        where(:published_at => { "$gte" => from.utc, "$lte" => till.utc })
      end
    }

  end
end
