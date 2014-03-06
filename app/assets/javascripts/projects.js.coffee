jQuery ->
  data = $("#hours-per-user").data("data")
  new Chart($("#hours-per-user").get(0).getContext("2d")).Pie(data)
