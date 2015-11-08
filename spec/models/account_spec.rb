# == Schema Information
#
# Table name: public.accounts
#
#  id         :integer          not null, primary key
#  subdomain  :string           default(""), not null
#  owner_id   :integer          default("0"), not null
#  created_at :datetime
#  updated_at :datetime
#

describe Account do
  describe "validations" do
    it { should validate_presence_of :owner }
    it { should validate_presence_of :subdomain }
    it { should validate_uniqueness_of :subdomain }

    it { should allow_value("defacto").for(:subdomain) }
    it { should_not allow_value("www").for(:subdomain) }
    it { should_not allow_value(".test").for(:subdomain) }
    it { should_not allow_value("test/").for(:subdomain) }

    it "should validate case insensitive uniqueness" do
      create(:account, subdomain: "defacto")
      expect(build(:account, subdomain: "Defacto")).to_not be_valid
    end
  end

  it "downcases subdomains" do
    account = create(:account, subdomain: "Defacto")
    expect(account.subdomain).to eq("defacto")
  end

  describe "associations" do
    it { should belong_to :owner }
  end

  describe "validation messages" do
    it "set for invalid characters" do
      account = build(:account, subdomain: "ść")
      account.valid?

      expect(account.errors.messages[:subdomain]).
        to eq ["contains invalid characters"]
    end

    it "set for restricted subdomain" do
      account = build(:account, subdomain: "admin")
      account.valid?

      expect(account.errors.messages[:subdomain]).
        to eq ["provided subdomain is restricted"]
    end
  end
end
