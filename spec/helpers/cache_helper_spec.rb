describe CacheHelper do
  describe "#cache_keys_for_all" do
    it "returns an array of cache keys" do
      create(:project)
      create(:category)

      expect(helper).to receive(:current_subdomain).
        and_return("some_subdomain").twice

      expect(helper.cache_keys_for_all(:projects, :categories).size).to eq(2)
    end
  end

  describe "#cache_key_for_current_user" do
    it "returns a different key for the current_user" do
      current_user = build(:user)
      other_user = build(:user)
      yet_another_user = build(:user)
      entry = build(:hour, user: current_user)

      expect(helper).to receive(:current_user).and_return(current_user)
      current_users_cache_key = helper.cache_key_for_current_user(entry)

      expect(helper).to receive(:current_user).and_return(other_user)
      other_users_cache_key = helper.cache_key_for_current_user(entry)

      expect(helper).to receive(:current_user).and_return(yet_another_user)
      yet_another_users_cache_key = helper.cache_key_for_current_user(entry)

      expect(current_users_cache_key).to_not eq(other_users_cache_key)
      expect(yet_another_users_cache_key).to eq(other_users_cache_key)
    end
  end
end
