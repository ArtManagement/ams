# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
consign_list_data = gon.consign_list_data

$ ->
  $('#consign_list').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: consign_list_data
    editurl: 'clientArray'
    colNames: ['委託日', '委託先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '状況', '委託価格', '消費税', '返却日', '仕入日','仕入価格','消費税','仕入先','備考','id', '伝票ID', '作品ID']
    colModel: [ { name:'consign_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'customer', width: 180, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'status', width: 60, sortable: false }
                { name:'consign_price', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'cancel_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'purchase_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'purchase_price', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'purchase_tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'supplier', width: 180, sortable: false }
                { name:'note', width: 200, sortable: false }
                { name:'id', width: 0, hidden: true }
                { name:'consign_slip_id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }]
    loadComplete: ->
      artwork_cnt = $('#consign_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#consign_list').jqGrid 'getCol', 'sale_price', false, 'sum'
      tax_sum = $('#consign_list').jqGrid 'getCol', 'tax', false, 'sum'
      t = document.getElementById('consign_list_sum')
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
  $('#consign_list_slip').click ->
    id = $("#consign_list").jqGrid('getGridParam','selrow')
    ret = $("#consign_list").jqGrid('getRowData',id)
    if ret.sale_slip_id
      window.open('/consign_slips/' + ret.sale_slip_id,'', 'height=720, width=1250')
    else
      window.open('/consign_slips/new','', 'height=720, width=1250')

# 作品詳細ボタン
  $('#consign_list_artwork').click ->
    id = $("#consign_list").jqGrid('getGridParam','selrow')
    ret = $("#consign_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/artworks/' + ret.artwork_id,'', 'height=600, width=1200')

# 検索ボタン
  $('#consign_lists_search').click ->
    date_from = document.getElementById('consign_lists_date_from').value
    date_to = document.getElementById('consign_lists_date_to').value
    artist_id = document.getElementById('consign_lists_artist_id').value
    title = document.getElementById('consign_lists_title').value
    customer_id = document.getElementById('consign_lists_customer_id').value
    category_id = document.getElementById('consign_lists_category_id').value
    technique_id = document.getElementById('consign_lists_technique_id').value
    format_id = document.getElementById('consign_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/consign_lists/search'
      async: false
      datatype: 'json'
      data: date_from: date_from, date_to: date_to, artist_id: artist_id, title: title, customer_id: customer_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (consign_search_data)->
        $("#consign_list").clearGridData()
        consign_list_data = consign_search_data
        $('#consign_list').jqGrid('setGridParam', {datatype: 'local',data: consign_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
