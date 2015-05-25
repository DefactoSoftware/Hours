require "spec_helper"

describe EmailHelper do
  describe "#current_subdomain" do
    it "returns empty subdomain if tenant is public" do
      expect(helper.current_subdomain).to eq('')
    end

    it "returns empty subdomain if tenant SINGLE_TENANT_MODE is true" do
      ENV["SINGLE_TENANT_MODE"] = "true"
      expect(helper.current_subdomain).to eq("")
    end

  end
end
