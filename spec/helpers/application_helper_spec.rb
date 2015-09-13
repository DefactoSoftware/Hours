describe ApplicationHelper do
  include ApplicationHelper

  describe "#client_title" do
    it "returns an image when there's a logo" do
      client = build(:client, logo: fixture_file_upload("logo.png"))

      expect(client_title(client)).to include("<img class=\"logo\" src=\"#{client.logo_url}\" alt=\"Logo\"")
    end

    it "shows a hashtel circle when there's no logo" do
      client = create(:client)

      expect(client_title(client)).to include("<span class=\"color\"")
    end
  end
end
