RSpec::Matchers.define :have_canonical do |path|
  match do |page|
    page.should have_selector "link[rel='canonical'][href$='#{path}']"
  end
end
