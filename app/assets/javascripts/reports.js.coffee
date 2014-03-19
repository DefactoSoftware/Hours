parseDate = d3.time.format("%Y-%m-%d").parse

formatDate = (date) ->
  new Date(date.getFullYear(), date.getMonth(), date.getDate(), 11, 50, 50)

formatRowChart = (chart, group, dimension) ->
  chart
    .width(300)
    .height((group.all().length + 1) * 30)
    .margins({top: 20, left: 10, right: 10, bottom: 20})
    .group(group)
    .dimension(dimension)
    .renderLabel(true)
    .elasticX(true)
    .xAxis().ticks(4)

groupHoursBy = (dimension) ->
  dimension.group().reduceSum(dc.pluck('hours'))

reduceAdd = (p, v) ->
  v.tags.forEach (val, idx) ->
    p[val] = (p[val] or 0) + 1
    return
  p

reduceRemove = (p, v) ->
  v.tags.forEach (val, idx) ->
    p[val] = (p[val] or 0) - 1 #decrement counts
    return
  p

reduceInitial = -> {}

$.get "api/entries", (data) ->
  data.forEach (d) ->
    d.date = parseDate(d.date)
    return

  entries = crossfilter(data)

  dateDimension = entries.dimension (data) ->
    data.date

  hours = dateDimension.group().reduceSum(dc.pluck('hours'))
  minDate = formatDate(dateDimension.bottom(1)[0].date)
  maxDate = formatDate(dateDimension.top(1)[0].date)


  hoursChart  = dc.barChart("#chart-line-hoursperday")
  hoursChart
    .width(990)
    .height(200)
    .margins({top: 0, right: 50, bottom: 20, left: 40})
    .dimension(dateDimension)
    .group(hours)
    .centerBar(true)
    .gap(2)
    .x(d3.time.scale().domain([minDate, maxDate]))
    .round(d3.time.day.round)
    .xUnits(d3.time.days)

  projectDimension = entries.dimension (data) -> data.project
  hoursPerProject = groupHoursBy(projectDimension)
  formatRowChart(dc.rowChart("#project-rowchart"), hoursPerProject, projectDimension)

  categoryDimension = entries.dimension (data) -> data.category
  hoursPerCategory = groupHoursBy(categoryDimension)
  formatRowChart(dc.rowChart("#category-rowchart"), hoursPerCategory, categoryDimension)

  userDimension = entries.dimension (data) -> data.user
  hoursPerUser = groupHoursBy(userDimension)
  formatRowChart(dc.rowChart("#users-rowchart"), hoursPerUser, userDimension)

  tagsDimension = entries.dimension (data) -> data.tags

  tagsGroup = tagsDimension.groupAll().reduce(reduceAdd, reduceRemove, reduceInitial).value()

  tagsGroup.all = ->
    newObject = []
    for key of this
      if @hasOwnProperty(key) and key isnt "all"
        newObject.push
          key: key
          value: this[key]
    newObject

  tagsChart = dc.rowChart("#tags-rowchart")
  tagsChart
    .width(300)
    .height((tagsGroup.all().length + 1) * 30)
    .margins({top: 20, left: 10, right: 10, bottom: 20})
    .renderLabel(true)
    .dimension(tagsDimension)
    .group(tagsGroup)
    .filterHandler((dimension, filter) ->
      dimension.filter (d) ->
        (if tagsChart.filter()? then d.indexOf(tagsChart.filter()) >= 0 else true)
      filter
    ).xAxis().ticks(4)

  dc.dataCount("#data-count")
    .dimension(entries)
    .group(entries.groupAll())

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
  ).order(d3.ascending)

  dc.renderAll()
