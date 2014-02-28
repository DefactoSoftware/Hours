module DateAgoHelper
  def date_ago_in_words(date)
    if date.to_date == Date.today
      I18n.t("date.today")
    else
      I18n.t("date.date_ago", date: time_ago_in_words(date))
    end
  end
end
