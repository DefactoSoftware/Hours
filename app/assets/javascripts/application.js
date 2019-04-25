/* global Pikaday, Tagger, TagExpander */

//= require jquery
//= require jquery_ujs
//= require jquery.atwho
//= require moment
//= require pikaday
//= require chartjs
//= require select2
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

function getLanguage() {
  return I18n[$('body').data('language')] || I18n['en'];
};

$('.datepicker').each(function () {
  new Pikaday({
    field: this,
    format: getLanguage().date.format
  });
});

$('.alert').ready(function() {
  setTimeout(function() {
    $('#flash').fadeOut();
  }, 5000);
});

$(document).ready(function() {
  $('.submit-button').prop('disabled', true);
  $('#content').keyup(function() {
    $('.submit-button').prop('disabled', $(this).val() === '');
  });

  $('.modal-window').on('click', Hours.dismissModal).
    on('click', 'div', function(e) { e.stopPropagation();
  });

  // Timer Feature Starts
  var container = $('.hour_timer_value_div');
  var interval;
  var isStopped = true;
  var entry_type_option = 'manual'
  var currentDate = function () {
    // get client's current date
    var date = new Date();
    var utc = date.getTime() + (date.getTimezoneOffset() * 60000);
    var newDate = new Date(utc + 3600000)
    return newDate;
  };
  var StartDate = currentDate();
  
  var countdown = function () {
    var currentNewDate = currentDate();
    
    // difference of dates
    var difference = currentNewDate - StartDate;

    if (isStopped) {
      // stop timer
      clearInterval(interval);
      StartDate = currentDate();
      return;
    }
  
    // basic math variables
    var _second = 1000,
      _minute = _second * 60,
      _hour = _minute * 60,
      _day = _hour * 24;
    
    // calculate dates
    var hours = Math.floor(difference / _hour),
      minutes = Math.floor((difference % _hour) / _minute),
      seconds = Math.floor((difference % _minute) / _second);
    
    // fix dates so that it will show two digets
    hours = (String(hours).length >= 2) ? hours : '0' + hours;
    minutes = (String(minutes).length >= 2) ? minutes : '0' + minutes;
    seconds = (String(seconds).length >= 2) ? seconds : '0' + seconds;
  
    // set to DOM
    container.find('.hours').text(hours);
    container.find('.minutes').text(minutes);
    container.find('.seconds').text(seconds);

    interval = setInterval(countdown, 1000);
  }

  var resetTimerValuDiv = function() {
    // unset from DOM
    container.find('.hours').text('00');
    container.find('.minutes').text('00');
    container.find('.seconds').text('00');
  }

  var roundToHour = function(date) {
    p = 60 * 60 * 1000; // milliseconds in an hour
    return new Date(Math.round(date.getTime() / p ) * p);
  }

  $('.btn-group .switch').on('click', 'span', function(event) {
    event.preventDefault();
    var input = $(this).parent().siblings('.hour_entry_type_option').find('input[type=hidden]');
    if (input.length > 0) {
      if ($(this).attr('data-value').toString() === 'manual') {
        // set entry_type_option to timer
        $(this).attr('data-value', 'timer');
        entry_type_option = 'timer'
      } else if (($(this)).attr('data-value').toString() === 'timer') {
        // set entry_type_option to manual
        $(this).attr('data-value', 'manual');
        entry_type_option = 'manual'
        // set isStopped true to stop timer and reset timer div values
        isStopped = true;
        resetTimerValuDiv();
      }

      $('.hour_date').toggle();
      $('.hour_value').toggle();

      $('.hour_timer_value_div').toggle();

      $('#hours-tab input[type=submit]').toggle();
      $('#hours-tab .timer-btn').toggle();

      input.val($(this).attr('data-value').toString()).trigger('change');
      $(this).toggleClass('timer');
    }
  })

  $('#hours-tab .timer-btn').on('click', 'button.start-timer', function(event) {
    event.preventDefault();
    // start timer
    StartDate = currentDate();
    isStopped = false;
    countdown();

    $('.start-timer').hide();
    $('.stop-timer').show();
  })

  $('#hours-tab #new_hour').on('submit', function(event) {
    if (entry_type_option === 'timer') {
      // set isStopped true to stop timer and reset timer div values
      isStopped = true;
      var hours = Number(container.find('.hours').text()),
        minutes = Number(container.find('.minutes').text()),
        seconds = Number(container.find('.seconds').text());
      resetTimerValuDiv();
      var today = new Date();
      today.setHours(hours, minutes, seconds, 0);
      var roundedHour = Number(roundToHour(today).getHours());
      roundedHour = roundedHour <= 0 ? roundedHour + 1 : roundedHour

      $('#hours-tab input#hour_value').val(roundedHour);
      $('#hours-tab input#hour_timer_value').val(roundedHour);
      $('.stop-timer').hide();
      $('.start-timer').show();
    }
    // call the submit action of this simple_form_for -> #hours-tab #new_hour
    $('#hours-tab #new_hour').unbind('submit').submit()
  })
  // Timer Feature Ends

  $('#hour_project_id').select2();
  $('#hour_category_id').select2();
  $('#mileage_project_id').select2();
  $('#project_client_id').select2();

  if ($('body').hasClass('projects-index')) {
    new Tagger($('.taggable'));
  }

  if ($('.tags-list').length > 0) {
    new TagExpander();
  }

  $('#hour_description').atwho({
    at: '#',
    data: $('#hour_description').data('data')
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
