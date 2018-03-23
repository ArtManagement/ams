# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  payable_list_data = gon.payable_list_data
  $('#payable_list').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: payable_list_data
    editurl: 'clientArray'
    colNames: ['仕入日', '仕入先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '状況', '買掛金額', '仕入金額', '出金金額', '出金日', '備考', 'id', '作品ID']
    colModel: [ { name:'purchase_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'supplier', width: 180, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'status', width: 60, sortable: false }
                { name:'payable_amount', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'purchase_amount', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'payment_amount', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'payment_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'note', width: 200, sortable: false }
                { name:'id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }]
    loadComplete: ->
      artwork_cnt = $('#payable_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#payable_list').jqGrid 'getCol', 'payable_amount', false, 'sum'
      t = document.getElementById('payable_list_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = price_sum.toLocaleString()
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

# 作品詳細ボタン
  $('#payable_list_artwork').click ->
    id = $("#payable_list").jqGrid('getGridParam','selrow')
    ret = $("#payable_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/artworks/' + ret.artwork_id,'', 'height=600, width=1200')

# 検索ボタン
  $('#payable_lists_search').click ->
    date_from = document.getElementById('payable_lists_date_from').value
    date_to = document.getElementById('payable_lists_date_to').value
    artist_id = document.getElementById('payable_lists_artist_id').value
    title = document.getElementById('payable_lists_title').value
    supplier_id = document.getElementById('payable_lists_supplier_id').value
    category_id = document.getElementById('payable_lists_category_id').value
    technique_id = document.getElementById('payable_lists_technique_id').value
    format_id = document.getElementById('payable_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/payable_lists/search'
      async: false
      datatype: 'json'
      data: date_from: date_from, date_to: date_to, artist_id: artist_id, title: title, supplier_id: supplier_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (payable_search_data)->
        $("#payable_list").clearGridData()
        payable_list_data = payable_search_data
        $('#payable_list').jqGrid('setGridParam', {datatype: 'local',data: payable_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
