describe Message do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }

  end

  it "should creates a message" do
    message = Message.new(signup_params)
    message.save
    expect(message.name).to eq("Zoidberg")
    expect(message.email).to eq("zoidberg@planetexpress.co.uk")
    expect(Message.count).to eq(1)
  end

  it "should not create message when email is blank" do
    message = Message.new(signup_params(""))
    message.save
    expect(message.name).to eq("Zoidberg")
    expect(message.errors[message.errors.keys[0]][0]).to eq("can't be blank")
    expect(Message.count).to eq(0)
  end

  def signup_params(email="zoidberg@planetexpress.co.uk")
    {
      title: "Help",
      name: "Zoidberg",
      email: email,
      body: "whoop whoop whoop"
    }
  end
end