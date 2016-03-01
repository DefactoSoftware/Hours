$ ->
  if $('#locale').length > 0
    $('#language').on 'change', (e) ->
      $('#locale').submit()
      return
