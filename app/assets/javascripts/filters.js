var Hours = Hours || {};

Hours.reportFilter = {
  init: function() {
    $("#clients").change(function(event) {
      var clientId = event.target.value;
      Hours.reportFilter.getdata(clientId);
    });
  },

  getdata: function (clientId) {
    $.ajax
    ({
      url : "projects.json",
      data: { client_id : clientId }
    }).done(function (data)
    {
      $("#entry_filter_project_id").empty()

      var rows = $("<option value>" +  I18n[$('body').data('language')].projects + "</option>");

      $.each(data, function(i, j)
      {
        rows.push($("<option value=\"" + j.id + "\">" + j.name + "</option>")[0]);
      });

      $(rows).appendTo("#entry_filter_project_id");
    });
  }
}

$(function() {
  Hours.reportFilter.init();
});
