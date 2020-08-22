function isElementVisible($elementToBeChecked)
{
    var TopView = $(window).scrollTop();
    var BotView = TopView + $(window).height();
    var TopElement = $elementToBeChecked.offset().top;
    var BotElement = TopElement + $elementToBeChecked.height();
    return ((BotElement <= BotView) && (TopElement >= TopView));
}

$(window).scroll(function () {
    $( ".hidden" ).each(function() {
        $this = $(this);
        isOnView = isElementVisible($(this));
        if(isOnView && !$(this).hasClass('animate')){
            $(this).addClass('animate');
            startAnimation($(this));
        }
    });
});

function startAnimation($this) {
  $this.animate({
    width: "100%"
  }, 3000, function() {
    // Animation complete.
  });
}

