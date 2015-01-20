RSpec::Matchers.define :have_meta_tag do |name, content|
  match do |page|
    expect(page).to have_selector("meta[name='#{name}'][content='#{content}']", visible: false)
  end
end

RSpec::Matchers.define :have_noindex_tag do
  match do |page|
    expect(page).to have_meta_tag("robots", "noindex")
  end
end
