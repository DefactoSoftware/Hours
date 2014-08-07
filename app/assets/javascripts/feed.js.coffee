$ ->
  $(".timestamp").each (_, timestamp) ->
    timestamp = $(timestamp)
    locale = $("body").data("language")
    formatter = new DateFormatter(timestamp.data("timestamp"), locale)
    daysAgo = formatter.daysAgoInWords()
    timestamp.html(daysAgo)
