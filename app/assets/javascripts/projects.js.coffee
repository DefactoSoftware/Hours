jQuery ->

  # Hours per project diagram
  if $("#hours-per-project").length > 0
    data = $("#hours-per-project").data("data")
    new Chart($("#hours-per-project").get(0).getContext("2d")).Doughnut(data, {
        segmentStrokeWidth: 2,
        responsive: true,
        tooltipFontSize: 10
        tooltipFontStyle: "light",
        animationSteps: 50,
        animationEasing: 'easeOutQuart'
      })

  # Hours per user diagram
  if $("#hours-per-user").length > 0
    data = $("#hours-per-user").data("data")
    new Chart($("#hours-per-user").get(0).getContext("2d")).Pie(data, {
        segmentStrokeWidth: 2,
        responsive: false,
        animationSteps: 50,
        animationEasing: 'easeOutQuart'
      })

  # Category spent charts
  $('.spent-chart').each (i, el) ->
    $el = $(el)
    spent = $el.data('spent')
    color = $(el).data('color')
    setTimeout (->
      new Chart(el.getContext('2d')).Doughnut(
        [
          { value: spent, color: color },
          { value: 100-spent, color: '#E2EAE9' }
        ],
        {
          percentageInnerCutout: 80,
          showTooltips: false,
          animationSteps: 50,
          animationEasing: 'easeOutQuart'
        })
      ), 200 * i
