jQuery ->
BAR_CHART_CONFIG = {
  scaleShowGridLines: false,
  scaleGridLineColor: 'transparent',
  scaleFontFamily: "'OpenSans'",
  scaleFontColor: '#ccc',
  fillColor: '#bbbbbb',
  responsive: true
}

LINE_CHART_CONFIG = {
  datasetStrokeWidth : 0.1,
  pointDotRadius : 1
  scaleShowGridLines: false,
  scaleGridLineColor: 'transparent',
  scaleFontFamily: "'OpenSans'",
  scaleFontColor: '#ccc',
  fillColor: '#bbbbbb',
  responsive: true
}

DOUGHNUT_CHART_CONFIG = {
  tooltipFontSize: 10
  tooltipFontStyle: "light",
  animationSteps: 50,
  animationEasing: 'easeOutQuart',
  segmentStrokeWidth: 2
}

PIE_CHART_CONFIG = {
  segmentStrokeWidth: 2,
  responsive: false,
  animationSteps: 50,
  animationEasing: 'easeOutQuart'
}

# Hours per project diagram
if $("#hours-per-project").length > 0
  data = $("#hours-per-project").data("data")
  new Chart($("#hours-per-project").get(0).getContext("2d")).Doughnut(data, DOUGHNUT_CHART_CONFIG)

$(".pie-chart").each (index, chart) =>
  data = $(chart).data("data")
  new Chart($(chart).get(0).getContext("2d")).Pie(data, PIE_CHART_CONFIG)

if $('#bar-chart').length > 0
  $canvas = $('#bar-chart');
  data = $canvas.data('data');
  context = $canvas[0].getContext('2d');
  new Chart(context).Bar(data, BAR_CHART_CONFIG)

if $('#line-chart').length > 0
  $canvas = $('#line-chart');
  data = $canvas.data('data');

  context = $canvas[0].getContext('2d');
  new Chart(context).Line(data, LINE_CHART_CONFIG)

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
