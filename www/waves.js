/*
 * Demo of https://github.com/isuttell/sine-waves
 */
var amp1 = Math.floor((Math.random() * 50) + 1);
var amp2 = Math.floor((Math.random() * 100) + 1);
var amp3 = Math.floor((Math.random() * 200) + 1);
var amp4 = Math.floor((Math.random() * 400) + 1);
var amp5 = Math.floor((Math.random() * 600) + 1);

var waves = new SineWaves({
  el: document.getElementById('waves'),
  speed: 3,
  width: function() {
    return $(window).width();
  },
  
  height: function() {
    return $(window).height();
  },
  
  ease: 'SineInOut',
  
  wavesWidth: '70%',
  
  waves: [
    {
      timeModifier: 4,
      lineWidth: 1,
      amplitude: -amp1,
      wavelength: amp1
    },
    {
      timeModifier: 2,
      lineWidth: 2,
      amplitude: -amp2,
      wavelength: amp2
    },
    {
      timeModifier: 1,
      lineWidth: 1,
      amplitude: -amp3,
      wavelength: amp3
    },
    {
      timeModifier: 0.5,
      lineWidth: 1,
      amplitude: -amp4,
      wavelength: amp4
    },
    {
      timeModifier: 0.25,
      lineWidth: 2,
      amplitude: -amp5,
      wavelength: amp5
    }
  ],
 
  // Called on window resize
  resizeEvent: function() {
    var gradient = this.ctx.createLinearGradient(0, 0, this.width, 0);
    gradient.addColorStop(0,"transparent");
    gradient.addColorStop(0.7,"rgba(234, 95, 35, 0.5)");
    gradient.addColorStop(1,"transparent");
    
    var index = -1;
    var length = this.waves.length;
	  while(++index < length){
      this.waves[index].strokeStyle = gradient;
    }
    // Clean Up
    index = void 0;
    length = void 0;
    gradient = void 0;
  }
});