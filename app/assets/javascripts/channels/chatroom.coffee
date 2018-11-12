App.chatroom = App.cable.subscriptions.create {channel: "ChatroomChannel"},
  connected: ->
    submit_message()
    scroll_bottom()

  received: (data) ->
    $("#messages-container").append data.message
    scroll_bottom()


submit_message = () ->
  $('#message-input').on 'keydown', (event) ->
    if event.keyCode is 13
      $('#message-input').click()
      event.target.value = ""
      event.preventDefault()

scroll_bottom = () ->
  $('#messages-container').scrollTop($('#messages-container')[0].scrollHeight)
