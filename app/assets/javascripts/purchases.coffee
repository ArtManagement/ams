# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

# 新規ボタン
  $('#purchase_new').click ->
#    slip_id = ('#purchase_slip_id').val()
    param = location.search
    location.href = '/purchases/new' + param

# 仕入No変更
  $('#purchase_id').on ->
    alert 'on'
  $('#purchase_id').change ->
    param = location.search
    location.href = '/purchases/' + $('#purchase_id').val() + param

# 画像ボタン
  $('#purchase_image').click ->
    window.open('/images/','', 'height=560, width=1200')

# 登録更新ボタン
