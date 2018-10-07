feature "Sending Message" do
  let(:subdomain) { generate(:subdomain) }

  scenario "should allow guest to send message" do
    send_message(subdomain)
    expect(page).to have_content('Message sent successfully')
    expect(Message.count).to eq(1)
  end

  scenario "should return error if email is not supplied" do
    send_message(subdomain, "")
    expect(page).to have_content('Opps... an error occur, please try again later')
    expect(Message.count).to eq(0)
  end

  def send_message(subdomain, email="john@example.com")
    visit root_url(subdomain: false)
    find('a[id$="contact-us"]').click

    fill_in :message_name, with: "Medale"
    fill_in :message_title, with: "Help"
    fill_in :message_email, with: email
    fill_in :message_body, with: "Help me"

    click_button "Submit"
  end
end