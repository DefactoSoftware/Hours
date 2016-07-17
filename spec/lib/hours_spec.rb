describe Hours do
  context "helpful_enabled" do
    it "returns false when there's no account or url" do
      allow(Hours).to receive(:helpful_account).and_return false
      allow(Hours).to receive(:helpful_url).and_return false
      expect(Hours.helpful_enabled?).to eq(false)
    end

    it "raises an error when the account or url is empty" do
      allow(Hours).to receive(:helpful_account).and_return ""
      allow(Hours).to receive(:helpful_url).and_return ""
      expect { Hours.helpful_enabled? }. to raise_error(RuntimeError)
    end

    it "returns true when account and url are set" do
      allow(Hours).to receive(:helpful_account).and_return "Helpful account"
      allow(Hours).to receive(:helpful_url).and_return "www.helpful.com/messages"
      expect(Hours.helpful_enabled?).to eq(true)
    end
  end
end

