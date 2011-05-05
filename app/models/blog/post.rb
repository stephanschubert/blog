module Blog
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Slug

    belongs_to :user, inverse_of: :posts

    field :title, type: String
    validates_presence_of :title
    slug :title

    field :body, type: String
    validates_presence_of :body

    field :published_at, type: DateTime

    # TAGS ---------------------------------------------------------------------

    embeds_many :tags, :class_name => "Blog::Tag" do
      def to_s
        map(&:name).join(Blog::Tag.separator)
      end
    end

    scope :tagged_with, lambda { |*tags|
      options   = tags.extract_options!
      attr_name = options[:slug] ? "slug" : "name"

      values = tags.map do |tag|
        if tag.is_a?(String)
          tag
        else
          tag.read_attribute(attr_name)
        end
      end

      where(:"tags.#{attr_name}".in => values)
    }

    # --------------------------------------------------------------------------

    # Return posts published +before+ a point in time or
    # published in a given +year+ (and +month+)

    scope :published, lambda { |before = Time.now, month = nil|
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

    # Return the latest +max+ posts
    scope :latest, lambda { |max| order_by(:published_at.desc).limit(max) }

  end
end
