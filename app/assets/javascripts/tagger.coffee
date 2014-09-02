class window.Tagger
  HASHTAG_REGEXP = /#([a-zA-Z0-9]+)/g;
  SPACE_REGEXP = /\s/g;

  constructor: (element) ->
    @container = element
    @input = element.find('input')
    @input.change => @highlight()
    @input.keyup => @highlight()
    @highlight()

  highlight: ->
    text = @_pad(@input.val())
    text = @_tag(text);
    @container.find(".background-highlighter").html(text)

  # private

  _pad: (text) ->
    text.replace(SPACE_REGEXP, '&nbsp;')

  _tag: (text) ->
    text.replace(HASHTAG_REGEXP, '<span class="hashtag">#$1</span>')
