// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
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
//= require date-formatter
//= require feed
//= require_tree .


var Hours = Hours || {
  dismissModal: function() {
    $('.modal-state').attr('checked', false);
  }
};

var SelectedBillables = 0;

var picker = new Pikaday({
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

$(document).ready(function () {
  function countCheckedBoxes() {
    var selectedEntriesCount = $('.bill_checkbox:checked').length;
    var lang = $('body').data('language');
    $('#amount_marked_entries').text(I18n[lang].checked.pre + selectedEntriesCount + I18n[lang].checked.post);
  }

  $('#submit-billable-entries').click(function (e) {
    e.preventDefault();
    $('#billable-entries-form').submit();
  });

  $('#billable-entries-form').bind('ajax:complete', function() {
    window.location.reload();
  });

  $('.bill_checkbox').change(function (e) {
    countCheckedBoxes();
  });

  $('.bill-project').click(function (element) {
    var checked = $(element.target).prop('checked');
    $('input[data-project-id="' + $(element.target).attr('data-project-id') + '"]').each(function (index, element) {
      $(element).prop('checked', checked);
      countCheckedBoxes();
    });
  });
});
