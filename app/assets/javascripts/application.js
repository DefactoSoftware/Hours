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
//= require moment
//= require pikaday
//= require selectize
//= require Chart
//= require select2
//= require projects
//= require i18n
//= require date-formatter
//= require feed
//= require_tree .


var Hours = Hours || {
  dismissModal: function() {
    $('.modal-state').attr('checked', false);
  }
};

var picker = new Pikaday({
  field: $('#datepicker')[0],
  format: 'DD/MM/YYYY'
});

$(".alert").ready(function() {
  setTimeout(function() {
    $("#flash").fadeOut();
  }, 5000);
});

$("#entry_tag_list").selectize({
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

$(document).ready(function(){
  $('.submit-button').prop('disabled', true);
  $('#content').keyup(function() {
    $('.submit-button').prop('disabled', $(this).val() === '');
  });

  $('.modal-window').on('click', Hours.dismissModal).
    on('click', 'div', function(e) { e.stopPropagation();
  });

  $('#entry_project_id').select2();
  $('#entry_category_id').select2();
});

$(document).keyup(function(event) {
  var ESCAPE_KEY = 27;

  if (event.keyCode === ESCAPE_KEY) {
    Hours.dismissModal();
  }
});
