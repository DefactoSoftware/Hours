feature "User views Project Audit Trail" do
  let(:subdomain) { generate(:subdomain) }
  let(:user) { build(:user) }
  let(:project) { create(:project) }

  before(:each) do
    create(:account_with_schema, subdomain: subdomain, owner: user)
    sign_in_user(user, subdomain: subdomain)
  end

  scenario "links to audit path" do
    visit edit_project_url(project, subdomain: subdomain)
    #note that creation itself is already a change,
    #so the change-link is only not shown in case of a migration
    audit_link = page.find(".audit-link")
    expect(audit_link).to have_content("changes")
  end

  scenario "displays audit trail" do
    update_project

    visit project_audits_url(project, subdomain: subdomain)
    last_change = page.find(".audit:last-child")
    expect(last_change.find(".changes")).to have_content " to projectX"
  end

  private

  def update_project
    Audited.audit_class.as_user(user) do
      project.update_attribute(:name, "projectX")
    end
  end
end
