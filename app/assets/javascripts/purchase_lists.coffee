# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
purchase_list_data = gon.purchase_list_data

$ ->
  $('#purchase_list').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: purchase_list_data
    editurl: 'clientArray'
    colNames: ['id', '伝票ID', '作品ID', '伝票No', '仕入日', '仕入先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '仕入価格', '消費税', '返品日', '売上日','売上価格','売上先','備考']
    colModel: [ { name:'id', width: 0, hidden: true }
                { name:'purchase_slip_id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }
                { name:'purchase_slip_id', width: 0, hidden: true }
                { name:'purchase_date', width: 100, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'supplier', width: 200, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 200, sortable: false }
                { name:'size', width: 110, sortable: false }
                { name:'category', width: 120, sortable: false }
                { name:'formats', width: 70, sortable: false }
                { name:'purchase_price', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'cancel_date', width: 100, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'sale_date', width: 100, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'sale_price', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'customer', width: 200, sortable: false }
                { name:'note', width: 200, sortable: false } ]
    loadComplete: ->
      artwork_cnt = $('#purchase_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#purchase_list').jqGrid 'getCol', 'purchase_price', false, 'sum'
      tax_sum = $('#purchase_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('purchase_list_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()
      t.rows[1].cells[2].innerHTML = tax_sum.toLocaleString()
      t.rows[1].cells[3].innerHTML = (price_sum + tax_sum).toLocaleString()
    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1140
    height: 475
    shrinkToFit: false
    rowNum: 200
    loadonce: true
    viewrecords: true
    caption:''
# 伝票修正ボタン
  $('#purchase_list_slip').click ->
    id = $("#purchase_list").jqGrid('getGridParam','selrow')
    ret = $("#purchase_list").jqGrid('getRowData',id)
    if ret.purchase_slip_id
      window.open('/purchase_slips/' + ret.purchase_slip_id,'', 'height=720, width=1250')
    else
      window.open('/purchase_slips/new','', 'height=720, width=1250')

# 作品詳細ボタン
  $('#purchase_list_artwork').click ->
    id = $("#purchase_list").jqGrid('getGridParam','selrow')
    ret = $("#purchase_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/artworks/' + ret.artwork_id,'', 'height=600, width=1200')
