# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
trust_list_data = gon.trust_list_data

$ ->
  $('#trust_list').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: trust_list_data
    editurl: 'clientArray'
    colNames: ['受託日', '受託先', '作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '状況', '受託価格', '消費税', '返却日', '委託日','委託価格','消費税','委託先','備考','id', '伝票ID', '作品ID']
    colModel: [ { name:'trust_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'supplier', width: 180, sortable: false, frozen: true }
                { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'status', width: 60, sortable: false }
                { name:'trust_price', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'cancel_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'consign_date', width: 90, sortable: false, formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'Y-m-d'} }
                { name:'consign_price', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'consign_tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'customer', width: 180, sortable: false }
                { name:'note', width: 200, sortable: false }
                { name:'id', width: 0, hidden: true }
                { name:'trust_slip_id', width: 0, hidden: true }
                { name:'artwork_id', width: 0, hidden: true }]
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
    rowNum: 100000
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
      window.open('/artworks/' + ret.artwork_id,'', 'height=600, width=1200')

# 検索ボタン
  $('#trust_lists_search').click ->
    date_from = document.getElementById('trust_lists_date_from').value
    date_to = document.getElementById('trust_lists_date_to').value
    artist_id = document.getElementById('trust_lists_artist_id').value
    title = document.getElementById('trust_lists_title').value
    supplier_id = document.getElementById('trust_lists_supplier_id').value
    category_id = document.getElementById('trust_lists_category_id').value
    technique_id = document.getElementById('trust_lists_technique_id').value
    format_id = document.getElementById('trust_lists_format_id').value
    $.ajax
      type: 'GET'
      url: '/trust_lists/search'
      async: false
      datatype: 'json'
      data: date_from: date_from, date_to: date_to, artist_id: artist_id, title: title, supplier_id: supplier_id,
      category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (trust_search_data)->
        $("#trust_list").clearGridData()
        trust_list_data = trust_search_data
        $('#trust_list').jqGrid('setGridParam', {datatype: 'local',data: trust_list_data}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")
