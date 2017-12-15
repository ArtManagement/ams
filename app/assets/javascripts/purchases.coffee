# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

# 新規ボタン
  $('#purchase_new').click ->
    location.href = '/purchases/new?slip_id=' + $("#purchase_purchase_slip_id").val()

# 仕入No変更
  $('#purchase_id').on ->
    alert 'on'
  $('#purchase_id').change ->
    location.href = '/purchases/' + $('#purchase_id').val()
