module Hours
  def self.helpful_url
    ENV["HELPFUL_URL"]
  end

  def self.helpful_account
    ENV["HELPFUL_ACCOUNT"]
  end

  def self.helpful_enabled?
    if Hours.helpful_url.try(:empty) || Hours.helpful_account.try(:empty?)
      Helpful account not configured,
      to disable helpful support remove
      the HELPFUL_URL and HELPFUL_ACCOUNT env variables and restart your server.
      If you do wish to enable support, please configure these.
      MSG
    elsif !Hours.helpful_url.try(:empty) && !Hours.helpful_account.try(:empty?)
      false
    else
      true
    end
  end
end
