RSpec::Matchers.define :have_scope do |name, selector|
  match do |doc|
    doc.class.scopes[name].conditions.selector.should == selector
  end
end
