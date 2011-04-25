require 'spec_helper'

describe Blog::Tag do

  it { should be_mongoid_document }
  it { should be_timestamped_document }

  it { should have_field(:name).of_type(String) }
  it { should validate_presence_of(:name) }

  it { should have_slug(:name) }

end
