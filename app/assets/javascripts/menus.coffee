# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
#仕入関連
  $('#menu_purchase_slip').click ->
    window.open('/purchase_slips/new','', 'height=720, width=1250')

  $('#menu_purchase_cancel_slip').click ->
    window.open('/purchase_cancel_slips/new','', 'height=720, width=1250')

  $('#menu_purchase_list').click ->
    window.open('/purchase_lists','', 'height=768, width=1300')

#売上関連
  $('#menu_sale_slip').click ->
    window.open('/sale_slips/new','', 'height=720, width=1250')

  $('#menu_sale_cancel_slip').click ->
    window.open('/sale_cancel_slips/new','', 'height=720, width=1250')

  $('#menu_sale_list').click ->
    window.open('/sale_lists','', 'height=768, width=1300')

#受託関連
  $('#menu_trust_slip').click ->
    window.open('/trust_slips/new','', 'height=720, width=1250')

  $('#menu_trust_return_slip').click ->
    window.open('/trust_return_slips/new','', 'height=720, width=1250')

  $('#menu_trust_list').click ->
    window.open('/trust_lists','', 'height=768, width=1300')

#委託関連
  $('#menu_consign_slip').click ->
    window.open('/consign_slips/new','', 'height=720, width=1250')

  $('#menu_consign_return_slip').click ->
    window.open('/consign_return_slips/new','', 'height=720, width=1250')

  $('#menu_consign_list').click ->
    window.open('/consign_lists','', 'height=768, width=1300')

#出金関連
  $('#menu_payment_slip').click ->
    window.open('/payment_slips/new','', 'height=720, width=1250')

  $('#menu_payment_list').click ->
    window.open('/payment_lists','', 'height=768, width=1300')

  $('#menu_payable_list').click ->
    window.open('/payable_lists','', 'height=768, width=1300')

#入金関連
  $('#menu_receipt_slip').click ->
    window.open('/receipt_slips/new','', 'height=720, width=1250')

  $('#menu_receipt_list').click ->
    window.open('/receipt_lists','', 'height=768, width=1300')

  $('#menu_receivable_list').click ->
    window.open('/receivable_lists','', 'height=768, width=1300')

#出品関連
  $('#menu_exhibit_slip').click ->
    window.open('/exhibit_slips/new','', 'height=720, width=1250')

#在庫

  $('#menu_stock_list').click ->
    window.open('/stock_lists','', 'height=768, width=1300')
