require "mongoid/slug"

module Blog
  class Post
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::MultiParameterAttributes
    include Mongoid::Slug

    belongs_to :user, inverse_of: :posts, class_name: "Blog::User"

    field :title, type: String
    validates_presence_of :title
    slug :title

    field :body, type: String
    validates_presence_of :body

    field :published_at, type: Time

    field :page_title, type: String
    field :meta_description, type: String

    field :views, type: Integer, default: 0

    # TAGS -------------------------------------------------

    embeds_many :tags, :class_name => "Blog::Tag" do
      def to_s
        glue = Blog::Tag.separator + " "
        map(&:name).join(glue)
      end
    end

    scope :tagged_with, lambda { |*tags|
      tags      = [tags].flatten # Ensure we have a flat array
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

    def tag_list
      tags.to_s
    end

    after_save :update_tags

    def tag_list=(tag_list)
      @tag_list = tag_list
    end

    def update_tags
      return unless @tag_list

      sep = Blog::Tag.separator
      self.tags.destroy_all

      @tag_list.split(sep).map(&:strip).reject(&:blank?).map do |name|
        self.tags.create :name => name
      end
    end

    def related_posts(limit = nil)
      self.class.tagged_with(tags).where(:_id.ne => id).limit(limit)
    end

    def previous_post
      self.class.published.
        where(:published_at.lt => published_at.utc.to_time).
        desc(:published_at).
        limit(1).
        first
    end

    def next_post
      self.class.published.
        where(:published_at.gt => published_at.utc.to_time).
        asc(:published_at).
        limit(1).
        first
    end

    # ------------------------------------------------------

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
    scope :latest, lambda { |max| desc(:published_at).limit(max) }

    # ------------------------------------------------------

    def preferred_title
      page_title.blank? ? title : page_title
    end

  end
end
