module Blog
  module ApplicationHelper

    def javascripts_from_directory(dir, options = {})
      options.reverse_merge! \
      :javascripts_dir => "public/javascripts/",
      :recursive       => false,
      :except          => nil

      # javascripts_dir, recursive, exceptions =
      #   options.pluck(:javascripts_dir, :recursive, :except)

      javascripts_dir = options[:javascripts_dir]
      recursive       = options[:recursive]
      except          = options[:except]

      # Find files in sub-directories too?
      pattern = recursive ? "/**/*.js" : "/*.js"

      # Ensure exceptions is at least an empty array
      exceptions = [exceptions].flatten.compact

      Dir["#{javascripts_dir}#{dir}#{pattern}"].map do |fn|

        # Normalize the file's name - remove the root directory
        # and the file's extension because Rails' javascript_include_tag
        # doesn't expect it.
        fn = fn.sub(javascripts_dir, "").sub(/\.js$/, "")

        # Check our exceptions if this file should be ignored
        ignore_file = exceptions.any? do |e|
          case e
          when Regexp
            fn =~ e
          when String
            fn.split("/").last == e
          end
        end

        ignore_file ? nil : fn

      end.compact
    end

  end
end
