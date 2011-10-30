RSpec::Matchers.define :be_slugged_document do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Slug)
  end

  description do
    "be a slugged Mongoid document"
  end
end

RSpec::Matchers.define :have_slug do |name|
  match do |doc|
    doc.class.slugged_fields.include?(name.to_s)
  end

  description do
    "have slugged field #{name}"
  end
end
