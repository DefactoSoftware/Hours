require "spec_helper"

describe EmailHelper do
  describe "#current_subdomain" do
    it "returns empty subdomain if tenant is public" do
      expect(helper.current_subdomain).to eq('')
    end

    it "returns empty subdomain if tenant SINGLE_TENANT_MODE is true" do
      allow(Hours).to receive('single_tenant_mode?').and_return true
      allow(Hours).to receive('single_tenant_mode?').and_return false
      expect(helper.current_subdomain).to eq("")
    end

    it "returns subdomain if tenant SINGLE_TENANT_MODE is true" do
      allow(Hours).to receive('application_subdomain').and_return 'timer-counter'
      allow(Hours).to receive('single_tenant_mode?').and_return true
      expect(helper.current_subdomain).to eq("timer-counter")
    end

  end
end
