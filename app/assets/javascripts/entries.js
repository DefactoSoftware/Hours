$(document).ready(function () {
  $('.accordion-tabs').each(function() {
    var pageCount = 0;
    if (document.location.hash.substring(1) === 'mileages'){
      pageCount = 1;
    }
    $($(this).children('li')[pageCount]).children('a').
      addClass('is-active').next().
        addClass('is-open').show();
  });

  $('.accordion-tabs').on('click', 'li > a', function(event) {
    if (!$(this).hasClass('is-active')) {
      event.preventDefault();
      var accordionTabs = $(this).closest('.accordion-tabs');
      accordionTabs.find('.is-open').removeClass('is-open').hide();
      $(this).next().toggleClass('is-open').toggle();
      accordionTabs.find('.is-active').removeClass('is-active');
      $(this).addClass('is-active');
    } else {
      event.preventDefault();
    }
  });
});
