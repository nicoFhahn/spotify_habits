$(window).on("load",function() {
  $(window).scroll(function() {
    var windowBottom = $(this).scrollTop() + $(this).innerHeight();
    $(".fade").each(function() {
      /* Check the location of each desired element */
      var objectBottom = $(this).offset().top + $(this).outerHeight();
      
      /* If the element is completely within bounds of the window, fade it in */
      if (objectBottom < windowBottom) { //object comes into view (scrolling down)
        if ($(this).css("opacity")==0) {$(this).fadeTo(500,1);}
      } else { //object goes out of view (scrolling up)
        if ($(this).css("opacity")==1) {$(this).fadeTo(500,0);}
      }
    });
  }).scroll(); //invoke scroll-handler on page-load
});

$('.js-tab').click(function(event) {
  
  event.preventDefault();
  
  var tabpanid= $(this).attr("aria-controls"),
      tabpan = $("#"+tabpanid),
      tabgroup = $(this).closest('ul').data('tab-group'),
      tabgrouppanel = $("." + tabgroup +" .js-tab-panel"); // so multiple tab groups work with same script
  
  //panels
  tabgrouppanel.attr("aria-hidden","true").addClass("hidden");
  tabpan.attr("aria-hidden","false").removeClass("hidden");
  
  // tabs links
  $(this).attr("aria-selected","true").parent().addClass('active')
    .siblings().removeClass('active').children().attr("aria-selected","false");
  
  // focus panel
    tabpan.attr('tabindex','0'); // make focusable
    tabpan.focus(); // focus on element
    setTimeout(function(){ tabpan.removeAttr('tabindex'); }, 3000); // make unfocusable for future
});