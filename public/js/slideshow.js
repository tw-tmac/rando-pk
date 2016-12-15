SLIDES_DURATION = 20 //Pecha Kucha rule says it's a 20 seconds per slide
COUNTDOWN = 10       //10 seconds countdown to let the presenter be ready.. and to cache the slides
function launchIntoFullscreen(element) {
  if(element.requestFullscreen) {
    element.requestFullscreen();
  } else if(element.mozRequestFullScreen) {
    element.mozRequestFullScreen();
  } else if(element.webkitRequestFullscreen) {
    element.webkitRequestFullscreen();
  } else if(element.msRequestFullscreen) {
    element.msRequestFullscreen();
  }
}

function init() {
  $("#restart").hide()

   clock = new FlipClock($('.clock'), COUNTDOWN, {
            clockFace: 'Counter',
            autoStart: true,
            countdown: true,
            callbacks: {
              start: function(){
                alert("grabbing images");
                $.ajax({
                  type: "GET",
                  url: '/cache-images'
                })
              },
              stop: function() {
                $("#clock").hide();
                $("#slides").show();
                loadSlides();
              }
            }
          });
      clock.start();
}

function startProgressBar(){
  $("#progressTimer").progressTimer({
    timeLimit: SLIDES_DURATION - 1,  //seconds
    baseStyle: 'progress-bar-info',
    warningStyle: 'progress-bar-warning',
    completeStyle: 'progress-bar-danger'
  });
}

function loadSlides() {
  startProgressBar();
  slider = $('.bxslider').bxSlider({
    auto: true,
    infiniteLoop: false,
    autoControls: false,
    adaptiveHeight: true,
    pager: false,
    pause: SLIDES_DURATION * 1000, //milliseconds
    onSlideNext: function($slideElement, oldIndex, newIndex){
      startProgressBar();
      slideCount = slider.getSlideCount()
      if(newIndex+1 == slideCount)
      {
        $("#restart").show()
      }
    }
  });
}
