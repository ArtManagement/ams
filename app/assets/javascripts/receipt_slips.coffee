# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
receipt_data = gon.receipt_data
receipt_artwork_id = gon.receipt_artwork_id

$ ->
  $('#receipt_slip').jqGrid
    styleUI: 'Bootstrap'
    datatype: 'local'
    data: receipt_data
    editurl: 'clientArray'
    colNames: [ '', '作品No', '作家名', 'タイトル', 'ＥＤ・号数', '分類・技法', '売掛金額', '状況', '入金金額', '売上金額', '備考', 'id', '作品id']
    colModel: [ { name:'actions', width: 40, formatter: "actions", formatoptions: {keys: false,editbutton: false, delbutton: true, delOptions: {}}}
                { name:'artwork_no', width: 100, editable: true, sortable: false, edittype: "select",
                editoptions: { value: receipt_artwork_id , dataInit: (artwork_id) -> $(artwork_id).select2 theme: "bootstrap", dropdownAutoWidth: true,  width: "1080px" } }
                { name:'name', width: 180, sortable: false }
                { name:'title', width: 260, sortable: false }
                { name:'size', width: 100, sortable: false }
                { name:'category', width: 140, sortable: false }
                { name:'receivable_amount', width: 100, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalplaces: 0, defaultValue: '' } }
                { name:'status', width: 80, sortable: false }
                { name:'amount', width: 120, editable: true, sortable: false, align : 'right', formatter: 'number', summaryType: 'sum',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalplaces: 0, defaultValue: '' } }
                { name:'sale_amount', width: 100, sortable: false, align : 'right', formatter: 'number',
                formatoptions: { decimalSeparator: ".",thousandsSeparator: ",", decimalplaces: 0, defaultValue: '' }}
                { name:'note', width: 200, sortable: false, editable: true, edittype: "textarea"}
                { name:'id', width: 0,hidden : true }
                { name:'artwork_id', width: 0,hidden : true } ]
    beforeEditCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#receipt_slip").jqGrid('getRowData',rowid)
        tmp = ret.artwork_no
    afterSaveCell: ( rowid, cellname, value, iRow, iCol ) ->
      if cellname == 'artwork_no'
        ret = $("#receipt_slip").jqGrid('getRowData',rowid)
        if ret.artwork_no != ''
          $.ajax
            type: 'GET'
            url: '/receipt_slips/artworkGet'
            async: false
            datatype: 'json'
            data: id: ret.id, sale_id: value, amount: ret.amount, note: ret.note, receipt_slip_id: $('#receipt_slip_id').val()
            success: (artwork_data) ->
              ret.artwork_no = artwork_data[0].artwork_no
              ret.name = artwork_data[0].name
              ret.title = artwork_data[0].title
              $("#receipt_slip").jqGrid('setRowData',rowid,ret)
          if value != 0 and ret.artwork_id == ""
            $('#receipt_slip').addRowData undefined,{artwork_id:'',amount:''}
      if cellname == 'amount'
        ret = $("#receipt_slip").jqGrid('getRowData',rowid)
        if ret.id != null
          $.ajax
            type: 'GET'
            url: '/receipt_slips/amountSet'
            async: false
            datatype: 'json'
            data: receipt_id: ret.id, amount: value, note: ret.note
    loadComplete: ->
      $('#receipt_slip').addRowData undefined,{artwork_id:'',amount:''}
      artwork_cnt = ($('#receipt_slip').jqGrid 'getCol', 'id', false, 'count') - 1
      amount_sum = $('#receipt_slip').jqGrid 'getCol', 'amount', false, 'sum'
      tax_sum = parseInt(($('#receipt_slip').jqGrid 'getCol', 'amount', false, 'sum' ) * $('#receipt_slip_tax_class_id').val() * $('#receipt_slip_tax_rate').val())
      amount_total = amount_sum + tax_sum
      t = document.getElementById('receipt_sum')
      t.rows[1].cells[0].innerHTML = artwork_cnt.toLocaleString()
      t.rows[1].cells[1].innerHTML = amount_sum.toLocaleString()

    multiselect: false
    autoencode: true
    cellEdit: true
    cellsubmit: 'clientArray'
    width: 1135
    height: 385
    shrinkToFit: false
    rowNum: 200
    sortname: 'id'
    loadonce: true
    viewrecords: true
    sortorder: 'asc'
    caption:''
#    pager: '#receipt_slip_pager'

#  $('#receipt_slip').navGrid '#receipt_slip_pager',{ edit: false, add: false, del: true, search: false, refresh: false, view: false, position: "left", cloneToTop: false }
# 新規伝票ボタン
  $('#receipt_slip_new').click ->
    location.href = '/receipt_slips/new'

# 作品登録ボタン
  $('#receipt_slip_artwork').click ->
    if $("#receipt_slip_id").val()
      id = $("#receipt_slip").jqGrid('getGridparam','selrow')
      ret = $("#receipt_slip").jqGrid('getRowData',id)
      if ret.artwork_id
        window.open('/artworks/' + ret.artwork_id,'', 'height=560, width=1200')

# 伝票No変更
  $('#receipt_slip_id').change ->
    location.href = '/receipt_slips/' + $('#receipt_slip_id').val()
