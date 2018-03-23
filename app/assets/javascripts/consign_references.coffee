# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  consign_reference = gon.consign_reference
  $('#consign_reference').jqGrid
    styleUI: 'Bootstrap4'
    iconSet: 'fontAwesome'
    datatype: 'local'
    data: consign_reference
    editurl: 'clientArray'
    colNames: ['作品No', '作家', 'タイトル', 'ＥＤ・号数', '分類・技法', '体裁', '仕入価格', '消費税', '作品ID']
    colModel: [ { name:'artwork_no', width: 85, sortable: false}
                { name:'artist', width: 140, sortable: false }
                { name:'title', width: 220, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'formats', width: 60, sortable: false }
                { name:'purchase_price', width: 110, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'purchase_tax', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalPlaces: 0, defaultValue: '' } }
                { name:'id', width: 0, hidden: true }]
    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1070
    height: 385
    shrinkToFit: false
    rowNum: 200
    loadonce: true
    viewrecords: true
    caption:''

# 作品登録ボタン
  $('#consign_reference_artwork').click ->
    id = $("#consign_reference").jqGrid('getGridParam','selrow')
    ret = $("#consign_reference").jqGrid('getRowData',id)
    if ret.id
      window.open('/artworks/' + ret.id,'', 'height=560, width=1200')

# 検索ボタン
  $('#consign_references_search').click ->
    artist_id = document.getElementById('consign_references_artist_id').value
    title = document.getElementById('consign_references_title').value
    category_id = document.getElementById('consign_references_category_id').value
    technique_id = document.getElementById('consign_references_technique_id').value
    format_id = document.getElementById('consign_references_format_id').value
    $.ajax
      type: 'GET'
      url: '/consign_references/search'
      async: false
      datatype: 'json'
      data: artist_id: artist_id, title: title, category_id: category_id, technique_id: technique_id, format_id: format_id
      success: (consign_reference_search)->
        $("#consign_reference").clearGridData()
        $('#consign_reference').jqGrid('setGridParam', {datatype: 'local',data: consign_reference_search}).trigger('reloadGrid')
      error:　-> alert("サーバーとの通信に失敗しました。")

# 選択ボタン
  $('#consign_reference_select').click ->
    artist_id = document.getElementById('consign_references_artist_id').value
    title = document.getElementById('consign_references_title').value
    category_id = document.getElementById('consign_references_category_id').value
    technique_id = document.getElementById('consign_references_technique_id').value
    format_id = document.getElementById('consign_references_format_id').value
    id = $("#consign_reference").jqGrid('getGridParam','selrow')
    slip_id = location.search.slice(9)
    ret = $("#consign_reference").jqGrid('getRowData',id)
    if ret.id
      $.ajax
        type: 'GET'
        url: '/consign_references/select'
        async: false
        datatype: 'json'
        data: slip_id: slip_id, artwork_id: ret.id, artist_id: artist_id, title: title, category_id: category_id, technique_id: technique_id, format_id: format_id
        success: (consign_reference_search)->
          $("#consign_reference").clearGridData()
          $('#consign_reference').jqGrid('setGridParam', {datatype: 'local',data: consign_reference_search}).trigger('reloadGrid')
        error:　-> alert("サーバーとの通信に失敗しました。")
