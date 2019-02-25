$(document).ready(function () {
  $('.accordion-tabs li').each(function (index, value) {
    var showDefault = (index === 0 && !document.location.hash);
    var anchor = $(value).children('a');

    if (document.baseURI === anchor[0].href || showDefault) {
      anchor.addClass('is-active').next().
        addClass('is-open').show();
    }
  });

  $('.accordion-tabs').on('click', 'li > a', function () {
    if ($(this).hasClass('is-active')) { return; }

    var accordionTabs = $(this).closest('.accordion-tabs');
    accordionTabs.find('.is-active').removeClass('is-active');
    accordionTabs.find('.is-open').removeClass('is-open').hide();

    $(this).addClass('is-active');
    $(this).next().toggleClass('is-open').show();
  });

  $('.project-select').on('change', function () {
    var projectId = $(this).val();
    if (projectId) {
      if (projectId === "0") {
        window.location = window.location.href.split('?')[0];
      } else {
        window.location = window.location.href.split('?')[0] + '?project_id=' + projectId;
      }
    }
    return false;
  });
});
