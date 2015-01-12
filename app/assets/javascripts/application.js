/* global Pikaday, Tagger, TagExpander */

//= require jquery
//= require jquery_ujs
//= require jquery.atwho
//= require moment
//= require pikaday
//= require selectize
//= require chartjs
//= require select2
//= require charts
//= require i18n
//= require billables
//= require date-formatter
//= require feed
//= require_tree .


var Hours = Hours || {
  dismissModal: function() {
    $('.modal-state').attr('checked', false);
  }
};

new Pikaday({
  field: $('#datepicker')[0],
  format: 'DD/MM/YYYY'
});

$('.alert').ready(function() {
  setTimeout(function() {
    $('#flash').fadeOut();
  }, 5000);
});

$('#entry_tag_list').selectize({
  valueField: 'tag',
  labelField: 'tag',
  searchField: 'tag',
  plugins: ['remove_button'],
  delimiter: ',',
  createOnBlur: true,
  persist: false,
  create: function(input) {
    return {
      value: input,
      tag: input
    };
  },
  load: function(query, callback) {
    var data = $('#entry_tag_list').data('data');
    if (!query.length) {
      return callback(data);
    }
    var result = $.grep(data, function(e) {
      return e.tag.indexOf(query) === 0;
    });
    return callback(result);
  }
});

$(document).ready(function() {
  $('.submit-button').prop('disabled', true);
  $('#content').keyup(function() {
    $('.submit-button').prop('disabled', $(this).val() === '');
  });

  $('.modal-window').on('click', Hours.dismissModal).
    on('click', 'div', function(e) { e.stopPropagation();
  });

  $('#entry_project_id').select2();
  $('#entry_category_id').select2();
  $('#project_client_id').select2();

  if ($('body').hasClass('projects-index')) {
    new Tagger($('.taggable'));
  }

  if ($('.tags-list').length > 0) {
    new TagExpander();
  }

  $('#entry_description').atwho({
    at: '#',
    data: $('#entry_description').data('data')
  });

  $('.modal-window')
    .on('click', Hours.dismissModal)
    .on('click', 'div', function(e) { e.stopPropagation(); });
});

$(document).keyup(function(event) {
  var ESCAPE_KEY = 27;

  if (event.keyCode === ESCAPE_KEY) {
    Hours.dismissModal();
  }
});

$(".project_billable > checkbox").ready(function () {
  enableBillableCheckbox();
});

$("#project_client_id").change(function () {
  enableBillableCheckbox();
});

var enableBillableCheckbox = function () {
  var disable = $("#project_client_id").val() === "";
  $("#project_billable").prop("disabled", disable);
}
