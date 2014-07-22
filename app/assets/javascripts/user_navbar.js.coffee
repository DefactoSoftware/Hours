jQuery ->
  $("#user-nav").click (event) ->
    event.stopPropagation()
    $(".dropdown-content").toggle()
    $(".dropdown-arrow").toggle()
  $("html").click ->
    $(".dropdown-content").hide()
    $(".dropdown-arrow").hide()

