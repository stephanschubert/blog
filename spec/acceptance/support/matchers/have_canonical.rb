RSpec::Matchers.define :have_canonical do |path|
  match do |page|
    expect(page).to have_selector("link[rel='canonical'][href$='#{path}']")
  end
end
