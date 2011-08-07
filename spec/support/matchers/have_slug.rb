RSpec::Matchers.define :have_slug do |name|
  match do |doc|
    doc.class.included_modules.should(include(Mongoid::Slug)) &&
    doc.class.slugged_fields.should(include(name.to_s))
  end
end
