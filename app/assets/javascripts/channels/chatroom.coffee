$ ->

	$('#message-input').on 'keydown', (event) ->
		if event.keyCode is 13
			$('#message-submit').click()
			event.target.value = ""
			event.preventDefault()

	scroll_bottom = () ->
		$('#messages-container').scrollTop($('#messages-container')[0].scrollHeight)

	scroll_bottom()

	chatroom_id = document.querySelector("#chatroom_id").value
	App.chatroom = App.cable.subscriptions.create {channel: "ChatroomChannel", chatroom_id: chatroom_id},

	received: (data) ->
		$("#messages-container").append data.message
		scroll_bottom()
