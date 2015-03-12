/* global I18n */

$(document).ready(function () {
  function countCheckedBoxes() {
    var selectedBilledEntriesCount = $('.bill-checkbox.billed:checked').length;
    var selectedUnbilledEntriesCount = $('.bill-checkbox.unbilled:checked').length;
    var totalEntriesCount = selectedBilledEntriesCount + selectedUnbilledEntriesCount;

    var lang = $('body').data('language');
    $('#amount_marked_entries').text(I18n[lang].checked.pre +
      totalEntriesCount + I18n[lang].checked.post);
    $('#submit-billable-entries-unbill').attr("disabled",
      selectedBilledEntriesCount === 0);
    $('#submit-billable-entries-bill').attr("disabled",
      selectedUnbilledEntriesCount === 0);
  }

  $('.bill-checkbox').change(function (event) {
    countCheckedBoxes();
    $(event.target).parents('tr').toggleClass('selected', event.target.checked);
  });

  $('.select-all').click(function (element) {
    var checked = $(element.target).prop('checked');
    $('input[data-project-id="' + $(element.target).attr('data-project-id') +
      '"][name^="' + $(element.target).attr('data-entry_type') + '_ids[]"').
      each(function (index, element) {
      $(element).prop('checked', checked).trigger("change");
    });
  });

  $(document).on("click", ".info-row", function (event){
    if (event.target.type !== "checkbox") {
      var checkbox = $(event.target).parents('tr').find('input[type=checkbox]')
      $(event.target).parents('tr').find('input[type=checkbox]').prop('checked',
        !checkbox.prop('checked')).trigger("change");
    }
  });
});

