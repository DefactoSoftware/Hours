parseDate = d3.time.format("%Y-%m-%d").parse

$.get "api/entries", (data) ->
  data.forEach (d) ->
    d.date = parseDate(d.date)
    return

  entries = crossfilter(data)

  dateDimension = entries.dimension (data) ->
    data.date

  hours = dateDimension.group().reduceSum(dc.pluck('hours'))
  minDate = dateDimension.bottom(1)[0].date
  maxDate = dateDimension.top(1)[0].date

  hoursChart  = dc.barChart("#chart-line-hoursperday")
  hoursChart.width(990).height(200).margins(
    top: 0
    right: 50
    bottom: 20
    left: 40
  ).dimension(dateDimension).group(hours).centerBar(true).gap(2).x(d3.time.scale().domain([
    minDate
    maxDate
  ])).round(d3.time.day.round).alwaysUseRounding(false).xUnits d3.time.days

  projectDimension = entries.dimension (data) -> data.project

  hoursPerProject = projectDimension.group().reduceSum(dc.pluck('hours'))

  projectsChart = dc.rowChart("#project-rowchart")
  projectsChart
    .width(300)
    .height(200)
    .margins({top: 20, left: 10, right: 10, bottom: 20})
    .group(hoursPerProject)
    .dimension(projectDimension)
    .renderLabel(true)
    .elasticX(true)
    .xAxis().ticks(4)

  categoryDimension = entries.dimension (data) -> data.category

  hoursPerCategory = categoryDimension.group().reduceSum(dc.pluck('hours'))

  categoriesChart = dc.rowChart("#category-rowchart")
  categoriesChart
    .width(300)
    .height(200)
    .margins({top: 20, left: 10, right: 10, bottom: 20})
    .group(hoursPerCategory)
    .dimension(categoryDimension)
    .renderLabel(true)
    .elasticX(true)
    .xAxis().ticks(4)

  dc.dataTable("#data-table").dimension(dateDimension).group((d) ->
    format = d3.format("02d")
    d.date.getFullYear() + "/" + format((d.date.getMonth() + 1))
  ).size(10).columns([
    (d) ->
      format = d3.time.format("%Y-%m-%d")
      return format(d.date)
    (d) -> return d.project
    (d) -> return d.category
    (d) -> return d.hours
    (d) -> return d.user
    (d) -> return d.tags
  ]).sortBy((d) ->
    d.date
  ).order(d3.ascending).renderlet (table) ->
    table.selectAll(".dc-table-group").classed "info", true
    return

  dc.renderAll()
