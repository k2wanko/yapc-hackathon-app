
NicoAPI = require 'nicoapi'

nico = new NicoAPI

window.addEventListener 'DOMContentLoaded', ->
  $login = document.getElementById 'login'
  $email = document.getElementById 'email'
  $password = document.getElementById 'password'
  $container = document.getElementById 'container'
  $live_id_form = document.getElementById 'live_id_form'
  $live_id = document.getElementById 'live_id'
  $comment_list = document.getElementById 'comment_list'
  $comment_form = document.getElementById 'comment_form'
  $comment = document.getElementById 'comment'

  context = null
  live = null
  socket = null
  lastNo = 0

  onError = (e)->
    console.log e

  sendComment = (chat, key)->
    xml = """
    <chat mail="184" thread="#{live.status.ms.thread}" no="" vpos="" date="" user_id="#{live.status.user.user_id}" premium="#{live.status.user.is_premium}" ticket="#{live.thread.ticket}" postkey="#{key}">#{chat.body}</chat>
    """

  $comment_form.onsubmit = ->
    comment = $comment.value
    return false unless comment
    nico.live.postkey.get
      thread: live.status.ms.thread
      block: 
    
    false

  onChat = (chat)->
    return unless body = chat.body
    li = document.createElement 'li'
    premium = if chat.isPremium() then "<span> P</span>" else ""
    li.innerHTML = "<span>#{chat.user_id}</span><br/><span style=\"font-size:12px;\">#{body}</span>"
    $comment_list.appendChild li
    li.scrollIntoView()

  onCreatedSocket = (socket)->
    socket.on 'error', onError
    socket.on 'data', (data)->
      for c in data
        onChat(c)
    return

  onRequestID = (id)->
    context.id = id
    nico.live.info.get(context)
    .then (res)->
      delete context.id
      live = res
      lastNo = live.thread.last_res
      console.log JSON.stringify live
      socket = new NicoAPI.MessageSocket
      socket.connect res.ms
      onCreatedSocket socket
    .catch onError

  $live_id_form.onsubmit = ->
    id = $live_id.value
    console.log id
    return false unless id
    onRequestID id
    false
  
  onSuccessLogin = (data)->
    context = data
    $login.classList.add 'hide'
    $container.classList.remove 'hide'

  $login.onsubmit = ->
    nico.users.login.post
      mail_tel: $email.value
      password: $password.value
    .then (res)->
      onSuccessLogin(res)
      res
    .catch onError
    false
