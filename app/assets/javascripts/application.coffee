# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery-ui
#= require turbolinks
#= require tether
#= require jquery3
#= require popper
#= require bootstrap-sprockets
#= require moment
#= require bootstrap-datetimepicker
#= require moment/ja
#= require select2
#= require select2_locale_"ja"
#= require autonumeric
#= require trirand/src/jquery.jqGrid
#= require trirand/i18n/grid.locale-ja
#= require_tree .

$ ->
#select2
  $(".select-id").select2
    theme: "bootstrap"
    minimumResultsForSearch: 10

  $(".select-no").select2
    theme: "bootstrap"

#datetimepicker
  $(".date-picker").datetimepicker
      format: "YYYY-MM-DD",
      locale: "ja",
      dayViewHeaderFormat: "YYYY年 MMM",
      icons:
        previous: "fa fa-chevron-left",
        next: "fa fa-chevron-right"
