# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

# 新規ボタン
  $('#trust_new').click ->
#    slip_id = ('#trust_slip_id').val()
    param = location.search
    location.href = '/trusts/new' + param

# 仕入No変更
  $('#trust_id').on ->
    alert 'on'
  $('#trust_id').change ->
    param = location.search
    location.href = '/trusts/' + $('#trust_id').val() + param

# 画像ボタン
  $('#trust_image').click ->
    window.open('/images/','', 'height=560, width=1200')

# 登録更新ボタン
