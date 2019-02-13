class ThirdPartyMailer < ApplicationMailer
  include CSVDownload

  def csv_mail user, third_party_email
    @user = user
    @third_party_email = third_party_email
    date_now = Date.today.to_time.to_i
    path = "#{Rails.root}/public/#{date_now}.csv"

    EntryCSVGenerator.generate_to_file_system(@user.hours.by_date, @user.mileages.by_date, path)

    attachments['file'] = File.read(path)
    mail(to: @third_party_email, from: @user.email, subject: @user.name + "'s" + " " + "entries on Hours")
    File.delete(path)
  end
end
