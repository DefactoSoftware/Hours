/* global I18n */

$(document).ready(function () {
  function countCheckedBoxes() {
    var selectedEntriesCount = $('.bill_checkbox:checked').length;
    var lang = $('body').data('language');
    $('#amount_marked_entries').text(I18n[lang].checked.pre + selectedEntriesCount + I18n[lang].checked.post);
    $('#submit-billable-entries').attr("disabled", selectedEntriesCount === 0);
  }

  $('#submit-billable-entries').click(function (e) {
    e.preventDefault();
    $('#billable-entries-form').submit();
  });

  $('#billable-entries-form').bind('ajax:complete', function() {
    window.location.reload();
  });

  $('.bill_checkbox').change(function () {
    countCheckedBoxes();
  });

  $('.bill-project').click(function (element) {
    var checked = $(element.target).prop('checked');
    $('input[data-project-id="' + $(element.target).attr('data-project-id') +
      '"][name^="' + $(element.target).attr('data-entry_type') + '_to_bill[]"').
      each(function (index, element) {
      $(element).prop('checked', checked);
      countCheckedBoxes();
    });
  });
});
