require 'spec_helper'

describe Blog::TextHelper do

  describe "#truncate" do # ----------------------------------------------------

    it "should support a new option :words_only" do
      text  = "The quick brown fox jumps over the lazy dog."
      short = helper.truncate(text, :words_only => true, :length => 21)

      expect(short).to eq("The quick brown ...")
    end

  end

end
