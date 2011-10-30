# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "blog"
  s.summary     = "Insert Blog summary."
  s.description = "Insert Blog description."
  s.files       = Dir["{config,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.version     = "0.0.1"

  s.add_dependency 'RedCloth'
  # TODO Add santas-little-helpers?
end
