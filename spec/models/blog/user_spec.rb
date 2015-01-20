require 'spec_helper'

describe Blog::User do

  it { is_expected.to be_mongoid_document }
  it { is_expected.to be_timestamped_document }

  it { is_expected.to have_field(:name).of_type(String) }
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:posts) }

  it "should be valid using the factory" do
    expect(F.build("blog/user")).to be_valid
  end

end
