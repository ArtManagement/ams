# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
receipt_list_data = gon.receipt_list_data

$ ->
  $('#receipt_list').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: receipt_list_data
    editurl: 'clientArray'
    colNames: ['出金日', '出金先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '状況', '入金金額', '売上金額', '売上日','備考','id', '伝票ID', '作品ID']
    colModel: [ { name:'receipt_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'supplier', width: 180, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'status', width: 60, sortable: false }
                { name:'receipt_amount', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'sale_amount', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'sale_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'note', width: 200, sortable: false }
                { name:'id', width: 0, hidden: true }
                { name:'receipt_slip_id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }]
    loadComplete: ->
      artwork_cnt = $('#receipt_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#receipt_list').jqGrid 'getCol', 'receipt_amount', false, 'sum'
      tax_sum = $('#receipt_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('receipt_list_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()
    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1140
    height: 475
    shrinkToFit: false
    rowNum: 100000
    loadonce: true
    viewrecords: true
    caption:''
# 伝票修正ボタン
  $('#receipt_list_slip').click ->
    id = $("#receipt_list").jqGrid('getGridParam','selrow')
    ret = $("#receipt_list").jqGrid('getRowData',id)
    if ret.receipt_slip_id
      window.open('/receipt_slips/' + ret.receipt_slip_id,'', 'height=720, width=1250')
    else
      window.open('/receipt_slips/new','', 'height=720, width=1250')

# 作品詳細ボタン
  $('#receipt_list_artwork').click ->
    id = $("#receipt_list").jqGrid('getGridParam','selrow')
    ret = $("#receipt_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/artworks/' + ret.artwork_id,'', 'height=600, width=1200')

# 検索ボタン
  $('#receipt_lists_search').click ->
    date_from = document.getElementById('receipt_lists_date_from').value
    date_to = document.getElementById('receipt_lists_date_to').value
    artist_id = document.getElementById('receipt_lists_artist_id').value
    title = document.getElementById('receipt_lists_title').value
    supplier_id = document.getElementById('receipt_lists_supplier_id').value
    category_id = document.getElementById('receipt_lists_category_id').value
    technique_id = document.getElementById('receipt_lists_technique_id').value
    format_id = document.getElementById('receipt_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/receipt_lists/search'
      async: false
      datatype: 'json'
      data: date_from: date_from, date_to: date_to, artist_id: artist_id, title: title, supplier_id: supplier_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (receipt_search_data)->
        $("#receipt_list").clearGridData()
        receipt_list_data = receipt_search_data
        $('#receipt_list').jqGrid('setGridParam', {datatype: 'local',data: receipt_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
