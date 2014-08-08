class window.DateFormatter
  constructor: (date, locale) ->
    @date = new Date(date)
    @locale = I18n[locale || "en"]

  daysAgoInWords: ->
    return "#{@_days()} #{@locale.date.future}" if @_dateInFuture()

    switch @_days()
      when 1
        @locale.date.today
      when 2
        @locale.date.yesterday
      else
        "#{@_days()} #{@locale.date.dateAgo}"

  # private

  _dateInFuture: ->
    @date > new Date()

  _days: ->
    today = new Date()
    difference = Math.abs(today.getTime() - @date.getTime())
    Math.ceil(difference / (3000 * 3600 * 24))
