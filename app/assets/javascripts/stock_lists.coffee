# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
stock_list_data = gon.stock_list_data

$ ->
  $('#stock_list').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: stock_list_data
    editurl: 'clientArray'
    colNames: ['id', '伝票ID', '作品ID', '伝票No', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '上代', '下代', '備考']
    colModel: [ { name:'id', width: 0, hidden: true }
                { name:'stock_slip_id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }
                { name:'stock_slip_id', width: 0, hidden: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 200, sortable: false }
                { name:'size', width: 110, sortable: false }
                { name:'category', width: 120, sortable: false }
                { name:'formats', width: 70, sortable: false }
                { name:'stock_price', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'tax', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'note', width: 200, sortable: false } ]
    loadComplete: ->
      artwork_cnt = $('#stock_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#stock_list').jqGrid 'getCol', 'stock_price', false, 'sum'
      tax_sum = $('#stock_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('stock_list_sum')
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
  $('#stock_list_slip').click ->
    id = $("#stock_list").jqGrid('getGridParam','selrow')
    ret = $("#stock_list").jqGrid('getRowData',id)
    if ret.stock_slip_id
      window.open('/stock_slips/' + ret.stock_slip_id,'', 'height=720, width=1250')
    else
      window.open('/stock_slips/new','', 'height=720, width=1250')

# 作品詳細ボタン
  $('#stock_list_artwork').click ->
    id = $("#stock_list").jqGrid('getGridParam','selrow')
    ret = $("#stock_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/artworks/' + ret.id,'', 'height=600, width=1200')
    else
      window.open('/artworks/new','', 'height=600, width=1200')
