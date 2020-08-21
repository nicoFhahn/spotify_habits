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
                $element.removeClass('hidden');
                $element.addClass('fade-in-element');
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

