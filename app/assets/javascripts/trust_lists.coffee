# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
trust_list_data = gon.trust_list_data

$ ->
  $('#trust_list').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: trust_list_data
    editurl: 'clientArray'
    colNames: ['id', '伝票ID', '作品ID', '伝票No', '受託日', '受託先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '受託価格', '消費税', '返却日', '委託日','委託価格','委託先','備考']
    colModel: [ { name:'id', width: 0, hidden: true }
                { name:'trust_slip_id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }
                { name:'trust_slip_id', width: 0, hidden: true }
                { name:'trust_date', width: 100, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'supplier', width: 200, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 200, sortable: false }
                { name:'size', width: 110, sortable: false }
                { name:'category', width: 120, sortable: false }
                { name:'formats', width: 70, sortable: false }
                { name:'trust_price', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
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
      artwork_cnt = $('#trust_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#trust_list').jqGrid 'getCol', 'trust_price', false, 'sum'
      tax_sum = $('#trust_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('trust_list_sum')
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
  $('#trust_list_slip').click ->
    id = $("#trust_list").jqGrid('getGridParam','selrow')
    ret = $("#trust_list").jqGrid('getRowData',id)
    if ret.trust_slip_id
      window.open('/trust_slips/' + ret.trust_slip_id,'', 'height=720, width=1250')
    else
      window.open('/trust_slips/new','', 'height=720, width=1250')

# 作品詳細ボタン
  $('#trust_list_artwork').click ->
    id = $("#trust_list").jqGrid('getGridParam','selrow')
    ret = $("#trust_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/trusts/' + ret.id,'', 'height=600, width=1200')
    else
      window.open('/trusts/new','', 'height=600, width=1200')
