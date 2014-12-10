class window.TagExpander

  constructor: ->
    @all_tags = $('.tag')
    @assess_tags()
    $(window).resize => @assess_tags()
    $('#more-tags').click => @_show_all()

  assess_tags: ->
    @_show(0)

    if $(window).width() >= 1088
      if @all_tags.length > 10
        @_show(10)
        @_show_more_link(true)
      else
        @_show_all()

    else if $(window).width() >= 640
      if @all_tags.length > 5
        @_show(5)
        @_show_more_link(true)
      else
        @_show_all()

  # private

  _show: (num) ->
    $(".tags-list a").removeClass 'show'
    $(".tags-list a:lt(#{num})").addClass 'show'

  _show_all: ->
    @_show(@all_tags.length)
    @_show_more_link(false)

  _show_more_link: (show) ->
    if show
      $('#more-tags').addClass 'show'
    else
      $('#more-tags').removeClass 'show'
