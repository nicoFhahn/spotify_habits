$(document).ready(function() {

    /** ---------------------------- //
     *  @group viewport trigger script 
     * for adding or removing classes from elements in view within viewport
     *  @author @david
     *  use like this: add following to css stylesheets:    
            .foobar.in-view {
            @extend .fadeInUpBig;
            transform:rotate(90deg)}
        */
  
      // ps: disable on small devices!
    var $animationElements = $('.hidden');
    var $window = $(window);

    // ps: Let's FIRST disable triggering on small devices!
    var isMobile = window.matchMedia("only screen and (max-width: 768px)");
    if (isMobile.matches) {
        $animationElements.removeClass('hidden');
    }

    function checkIfInView() {

        var windowHeight = $window.height();
        var windowTopPosition = $window.scrollTop();
        var windowBottomPosition = (windowTopPosition + windowHeight);

        $.each($animationElements, function () {
            var $element = $(this);
            var elementHeight = $element.outerHeight();
            var elementTopPosition = $element.offset().top;
            var elementBottomPosition = (elementTopPosition + elementHeight);

//check to see if this current container is within viewport
            if ((elementBottomPosition >= windowTopPosition) &&
                (elementTopPosition <= windowBottomPosition)) {
                $element.addClass('fade-in-element');
                $element.removeClass('hidden');
            } else {
                $element.removeClass('fade-in-element');
                $element.addClass('hidden');
            }
        });
    }

    $window.on('scroll resize', checkIfInView);
    $window.trigger('scroll');


    /* @end viewport trigger script  */

});

$( document ).ready( function() {
  
  function cssTransitionFallback() {
    // Queue : false means both animations occur simultaneously 
    $( 'figure' ).hover(
      function() {
        
        $( 'figcaption' ).animate({
          opacity: 1
        }, { duration: 200, queue: false });
        
        $('img').animate({
          'left': '-5px',
          'max-width': '520px'
        }, { duration: 200, queue: false });
      }, 
      function() {

       $('figcaption').animate({
          opacity: 0
        }, { duration: 200, queue: false });
        
        $('img').animate({
          'left': '-20px',
          'max-width': '600px'
        }, { duration: 200, queue: false });
    });
  }
  
  // Only call the function if there's no transition support
  if( !Modernizr.csstransitions ) {
    cssTransitionFallback();
  } 
  
});