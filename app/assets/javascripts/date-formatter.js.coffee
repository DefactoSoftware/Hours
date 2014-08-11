class window.DateFormatter
  MS_PER_DAY = 1000 * 60 * 60 * 24

  constructor: (date, locale) ->
    @date = new Date(date)
    @locale = I18n[locale || "en"]

  daysAgoInWords: ->
    return "#{@_days()} #{@locale.date.future}" if @_dateInFuture()

    switch @_days()
      when 0
        @locale.date.today
      when 1
        @locale.date.yesterday
      else
        "#{@_days()} #{@locale.date.dateAgo}"

  # private

  _dateInFuture: ->
    @date > new Date()

  _days: ->
    today = @_UTCDate(new Date())
    date = @_UTCDate(@date)
    Math.floor((today - date) / MS_PER_DAY)

  _UTCDate: (date) ->
    Date.UTC(date.getFullYear(), date.getMonth(), date.getDate())
