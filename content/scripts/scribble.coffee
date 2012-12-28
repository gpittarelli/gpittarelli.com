$ ->
  $scribbleArea = $('#scribble')
  canvas = $scribbleArea[0]
  ctx = canvas.getContext '2d'

  resizeCanvas = ->
    console.log 'canvas size: ' + window.innerHeight + ',' + window.innerWidth
    canvas.height = window.innerHeight
    canvas.width = window.innerWidth
#    if window.devicePixelRatio == 2
#      ctx.scale(2, 2);

  resizeCanvas()
  $(window).resize resizeCanvas

  prev_x = prev_y = null

  start_draw = (x, y) ->
    prev_x = x
    prev_y = y

  stop_draw = ->
    prev_x = prev_y = null

  prev_x = prev_y = null
  draw = (x, y) ->
    if prev_x
      ctx.beginPath()
      ctx.moveTo prev_x, prev_y
      ctx.lineTo x, y
      ctx.stroke()

      prev_x = x
      prev_y = y

  $(document).mousedown (event) ->
    start_draw event.offsetX, event.offsetY

  $scribbleArea.mousemove (event) ->
    draw event.offsetX, event.offsetY

  $(document).mouseup stop_draw

  $(document).bind 'touchstart', (event) ->
    touch = event.originalEvent.touches[0]
    start_draw touch.pageX, touch.pageY

  $(document).bind 'touchmove', (event) ->
    event.preventDefault()
    touch = event.originalEvent.touches[0]
    draw touch.pageX, touch.pageY

  $(document).bind 'touchcancel', stop_draw
  $(document).bind 'touchend', stop_draw

  createTouchEventLogger = (eventName) ->
    (event) ->
      touches = event.originalEvent.touches
      coords_str = ('(' + t.pageX + ',' + t.pageY + ')' for t in touches)
      console.log('touch' + eventName + ': [' + coords_str + ']')

  ['start', 'end', 'move', 'enter', 'leave', 'cancel'].forEach (eventName) ->
    $(document).bind 'touch' + eventName, createTouchEventLogger(eventName)