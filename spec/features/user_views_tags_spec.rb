feature "User view tags overview" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }

  scenario "views a tag overview" do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)

    tag = create(:tag)
    project = create(:project)
    entry = create(:hour, user: user, project: project, value: 6)
    entry.tags << tag
    create(:hour, user: user, project: project, value: 6).tags << tag

    click_link "Projects"
    click_link tag.name

    hours_indication = I18n.t("tags.show.hours_indication")
    expect(page).to (
      have_content("#{tag.name} - 12 #{hours_indication}"))
    expect(page).to have_content(tag.name)
  end
end
