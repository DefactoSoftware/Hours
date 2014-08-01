require "spec_helper"

describe ApplicationHelper do
  include GravatarImageTag

  describe "#user_image_link", type: :helper do
    let(:user) { create(:user) }

    it "renders the gravatar url" do
      expect(user_image_link(user)).to include("https://secure.gravatar.com/avatar")
    end

    it "includes the border when specified" do
      expect(user_image_link(user, border: true)).to include("border: 3px")
    end

    it "renders the blocks content" do
      expect(
        user_image_link(user) { "woohoo" }
      ).to include("woohoo")
    end
  end
end
