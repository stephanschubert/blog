RSpec::Matchers.define :have_title do |title|
  match do |page|
    page.should have_xpath '//head/title', text: title
  end
end
