# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  receivable_list_data = gon.receivable_list_data
  $('#receivable_list').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: receivable_list_data
    editurl: 'clientArray'
    colNames: ['売上日', '売上先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '状況', '売掛金額', '売上金額', '入金金額', '入金日', '備考', 'id', '作品ID']
    colModel: [ { name:'sale_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'customer', width: 180, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'status', width: 60, sortable: false }
                { name:'receivable_amount', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'sale_amount', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'receipt_amount', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'receipt_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'note', width: 200, sortable: false }
                { name:'id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }]
    loadComplete: ->
      artwork_cnt = $('#receivable_list').jqGrid 'getCol', 'id', false, 'count'
      price_sum = $('#receivable_list').jqGrid 'getCol', 'receivable_amount', false, 'sum'
      t = document.getElementById('receivable_list_sum')
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

# 作品詳細ボタン
  $('#receivable_list_artwork').click ->
    id = $("#receivable_list").jqGrid('getGridParam','selrow')
    ret = $("#receivable_list").jqGrid('getRowData',id)
    if ret.artwork_id
      window.open('/artworks/' + ret.artwork_id,'', 'height=600, width=1200')

# 検索ボタン
  $('#receivable_lists_search').click ->
    date_from = document.getElementById('receivable_lists_date_from').value
    date_to = document.getElementById('receivable_lists_date_to').value
    artist_id = document.getElementById('receivable_lists_artist_id').value
    title = document.getElementById('receivable_lists_title').value
    customer_id = document.getElementById('receivable_lists_customer_id').value
    category_id = document.getElementById('receivable_lists_category_id').value
    technique_id = document.getElementById('receivable_lists_technique_id').value
    format_id = document.getElementById('receivable_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/receivable_lists/search'
      async: false
      datatype: 'json'
      data: date_from: date_from, date_to: date_to, artist_id: artist_id, title: title, customer_id: customer_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (receivable_search_data)->
        $("#receivable_list").clearGridData()
        receivable_list_data = receivable_search_data
        $('#receivable_list').jqGrid('setGridParam', {datatype: 'local',data: receivable_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
