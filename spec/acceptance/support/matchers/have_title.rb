RSpec::Matchers.define :have_title do |title|
  match do |page|
    expect(page).to have_xpath('//head/title', text: title)
  end
end
