RSpec::Matchers.define :have_meta_tag do |name, content|
  match do |page|
    page.should have_selector "meta[name='#{name}'][content='#{content}']"
  end
end

RSpec::Matchers.define :have_noindex_tag do
  match do |page|
    page.should have_meta_tag "robots", "noindex"
  end
end
