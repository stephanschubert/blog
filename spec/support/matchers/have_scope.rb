RSpec::Matchers.define :have_scope do |name, selector|
  match do |doc|
    expect(doc.class.scopes[name].conditions.selector).to eq(selector)
  end
end
