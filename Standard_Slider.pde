class Standard_Slider extends UI_Element {
  float l;    // length of Slider - length in direction of the value
  int size;  // size of Slider - width and general size of Slider are meant to scale with size (meant to be between 1-25 for 25 different Slidersizes)
  float min;   // lowest possible Value
  float max;   // highest possible Value
  float step;  // Stepsize between adjustable Values
  float CurVal; // current Value of the Slider
  int dc = 0;  // decimal places meant to be displayed by a Slider, given the Slider does display its Value
  Boolean Pressed = false; // whether slider is currently beeing pressed
  Boolean vert = false; // vertical/horizontal alignment of Slider

  Boolean doAnim = false;
  float Animline = 0;         // Size of animated line
  float[] Animflow;           // BezierCurve for animation
  PVector K2 = new PVector(0.68, 0.55);   // Controlpoints for Bezier
  PVector K3 = new PVector(0.265, 1);
  int sc = 1;             // Stepcounter of animation
  Boolean doFade = false;
  float lerp = 0.0;         // Linear Interpolation value for fading of animated line once its done

  ///ValueBox///
  Simple_Textbox VB;

  ///IncrementButtons///
  boolean IncrementButtons = true;
  Triangle_Button DB;
  Triangle_Button IB;

  Standard_Slider(float x_, float y_, float l_, int size_, float min_, float max_, float CurVal_, Boolean vert_) {
    super(x_, y_);
    l = constrain(l_, 100, 2000);
    size = constrain(size_, 1, 25);
    min = min_;
    max = max_;
    step = l/(max-min);
    CurVal = constrain(CurVal_, min_, max_);
    vert = vert_;
    Animflow = BezierCurve.calcBezier(K2, K3, 50);
    setupVB();
    setupIB();
  }

  //Updates all runtimesensitive variables from Animations and alike
  void update() {
    if(!mousePressed) { Pressed = false; }  //sets Pressed to false if the mouse is not pressed

    updateAnim();
    updateFade();
    updateCurVal();
    updateVB();
    updateIB();
    if(Pressed) { activate(); }
  }

  //Draws a visual representation of the Slider
  void display() {

    drawMainline();
    drawAnimline();
    drawMarkerlines();
    drawSlidercontroller();
    drawVB();
    drawIB();
  }

  //Setup the IncrementButtons
  void setupIB() { // TODO: set Triangle_Button to continually in-/decrement when IB/DB are held
    if(!vert) {
      IB = new Triangle_Button(12+l/2, 0,        -5, +size,    -5, -size,    +5, 0) {
        @ Override public void function() {
          CurVal = constrain(CurVal+pow(0.1, dc), min, max);
          VB.setOpacity(255);
        }
      };
      DB = new Triangle_Button(-12, 0,        +5, +size,    +5, -size,    -5, 0) {
        @ Override public void function() {
          CurVal = constrain(CurVal-pow(0.1, dc), min, max);
          VB.setOpacity(255);
        }
      };
    } else {
      //DB = new Triangle_Button(absX(),absY()+l/2,);
      //IB = new Triangle_Button(absX(),absY()-l/2,);
      // TODO: implement vertical version
    }
  }

  //Setup the ValueBox
  void setupVB() {
    if(!vert) {
      VB = new Simple_Textbox(str(CurVal), absX()-l/2+(CurVal-min)*step, absY()+size*2+25, size*2+40, size+20);
    } else {
      VB = new Simple_Textbox(str(CurVal), absX()+size*2.5+35, absY()+l/2-(CurVal-min)*step, size*2+40, size+20);
    }
    VB.setSW(int(size*0.25+1));
    VB.setOpacity(0);
  }

  //Update the Animline-animation while its active
  //    1. Set the length of the Animline to the next scaled Beziervalue (given a set increment of the current Bezierarrayindex)
  //    2. If the Animline is as long as the Mainline (length l), a bunch of Animline-animationvalues are reset and the Animation terminated
  //       Then the Fadeanimation is set up and started (doFade = true, lerp = 0)
  void updateAnim() {
      if(!Pressed) {
        if(doAnim) {
          sc = constrain(sc+2, 1, 50);         //If the Animation is active, but the Slider not pressed, the Animation is sped up, so it finishes faster and feels responsive
          Animline = Animflow[sc]*l;           //The length of the Animationline is updated
          if(Animline >= l) {                  //If the Animation is done, the Animation is ended, all values reset and the fadeAnimation started
            doAnim = false;
            Animline = 0;
            sc = 1;
            doFade = true;
            lerp = 0;
          }
        }
      } else {
        doAnim = true;                       //While the Slider is pressed the Animationline always has to be updated and drawn
        sc = constrain(sc+1, 1, 50);         //Incrementing the stepcounter to access the next Beziervalue
        Animline = Animflow[sc]*l;           //Updating the length of the Animationline with the new Beziervalue
      }
  }

  //Updates the Fadecolor of the Mainline wile the Fadeanimation is active
  void updateFade() {
    if(!Pressed) {
      if(doFade) {               //If the Sliders color is meant to fade from the darker tone of the Animationline to the lighter basetone of the Slider, the linear-Interpolationvalue is incremented
        lerp = constrain(lerp + 0.025, 0, 1);              //This linear-Interpolationvalue will later be used to interpolate between the Animline color and the Slider basecolor towards the basecolor
        if(lerp >= 1) {                                    //If the lerpvalue has reached one, the fade is complete
          doFade = false;                                  //So doFade is set to false and lerp reset to 0
          lerp = 0;
        }
      }
    }
  }

  //Updates CurVal when the Slider is pressed, so you can adjust the Slidervalue by dragging the Slidercontroller
  void updateCurVal() {
    if(Pressed) {
      if(!vert) {           //Updating CurVal for horizontal and vertical Sliders if pressed
        CurVal = constrain((mouseX-absX()+l/2)/step+min, min, max);
      } else {
        CurVal = constrain((-mouseY+absY()+l/2)/step-min, min, max);
      }
    }
  }

  //Updates the ValueBox
  void updateVB() {
    if(!vert) {          //Update Coordinates with SliderControllerposition
      VB.setX(absX()-l/2+(CurVal-min)*step);
    } else {
      VB.setY(absY()+l/2-(CurVal-min)*step);
    }
    if(!Pressed) {        //Update Opacity when the Slider is being Pressed or Released
      VB.setOpacity(VB.getOpacity()-5);
    } else {
      VB.setOpacity(255);
    }
    if(dc == 0) {   //update the displayed Value
      VB.setLabel(str(int(CurVal)));
    } else {
      VB.setLabel(nf(CurVal, 1, dc));
    }
  }

  //Updates the Increment/Decrement Buttons
  void updateIB() {
    IB.update();
    DB.update();
  }

  //Draws a Mainline that's the base of the Slider
  //When the Fadeanimation is active, the color of the Mainline is linearly interpolated
  //to blend between the end of the Press/Animlineanimation and the idle state of the Slider
  void drawMainline() {
    strokeWeight(size*2+4);
    stroke(200);
    if(doFade) {     //Setting the Fadecolor
      stroke(lerp(150, 200, lerp));
    }
    if(!vert) {
       line(absX()+l/2,absY(), absX()-l/2,absY());    //horizontal Mainline
    } else {
       line(absX(),absY()+l/2, absX(),absY()-l/2);   //vertical Mainline
    }
  }

  //Draws a darker line over the lighter Mainline, when the Slider is pressed
  //As the Slider is pressed the Animationline grows in length until it is the same length as the Mainline
  //When the Slider is released the Animationline finishes its animation:
  //    1. If the Animline isn't as long as the Mainline, it grows faster in length until it has the same length as the Mainline
  //    2. If the Animline is the same length as the Mainline it ceases being drawn and transitions into the Fadeanimation
  void drawAnimline() {
    if(doAnim) {
        stroke(150);
        strokeWeight(size*2+4);
        if(!vert) {                         //horizontal Overlayed Animationline
          line(constrain(absX()-l/2+(CurVal-min)*step-(Animline/2), absX()-l/2, absX()+l/2-Animline), absY(),
               constrain(absX()-l/2+(CurVal-min)*step+(Animline/2), absX()-l/2+Animline, absX()+l/2), absY());
        } else {                            //vertical Overlayed Animationline
          line(absX(),constrain(absY()+l/2-(CurVal-min)*step-(Animline/2), absY()-l/2, absY()+l/2-Animline),
               absX(),constrain(absY()+l/2-(CurVal-min)*step+(Animline/2), absY()-l/2+Animline, absY()+l/2));
        }
      }
  }

  //Draws a Spineline along the length of the Mainline
  //and some perpendicular Markerlines to give the Slider some texture
  void drawMarkerlines() {
    strokeWeight(2);
    stroke(170);
    if(!vert) {
      line(absX()-l/2, absY(), absX()+l/2, absY());    //vertical first Markerline
      for(int i=1; i<10; i++) {
        line(absX()-l/2+i*l/10, absY()-size/2, absX()-l/2+i*l/10, absY()+size/2);   //vertical Markerlines     (vertical since they are perpendicular to the Mainline and Spineline)
      }
      line(absX(), absY()-size/2, absX(), absY()+size/2);   //horizontal Spineline
    } else {
      line(absX(), absY()-l/2, absX(), absY()+l/2);    //horizontal first Markerline
      for(int i=1; i<10; i++) {
        line(absX()-size/2, absY()-l/2+i*l/10, absX()+size/2, absY()-l/2+i*l/10);   //horizontal Markerlines    (horizontal since they are perpendicular to the Mainline and Spineline)
      }
      line(absX()-size/2, absY(), absX()+size/2, absY());   //vertical Spineline
    }
  }

  //Draws the Slidercontroller aka. the big thing you drag around to adjust the Slidervalue (It also indicates the current value)
  //The position of the Slidercontroller is calculated through the current Slidervalue,
  //the minimum and maximum Slidervalues and other positioningvariables
  void drawSlidercontroller() {
    if(!Pressed) {                   //horizontal/vertical Slidercontroller when not pressed
        strokeWeight(size/4+2);
        stroke(120);
        fill(200);
        if(!vert) { ellipse(absX()-l/2+(CurVal-min)*step, absY(), size*3+10,size*3+10);
        } else { ellipse(absX(),absY()+l/2-(CurVal-min)*step,size*3+10,size*3+10); }
      } else if(Pressed) {             //horizontal/vertical Slidercontroller when pressed
        stroke(120);
        fill(200);
        strokeWeight(size/2+2);
        if(!vert) { ellipse(absX()-l/2+(CurVal-min)*step, absY(), size*3+10-size/4,size*3+10-size/4);
        } else{ ellipse(absX(),absY()+l/2-(CurVal-min)*step,size*3+10-size/4,size*3+10-size/4); }
      }
  }

  //Draws the ValueBox
  void drawVB() {
    VB.displayUI();
  }

  //Draws the IncrementButtons
  void drawIB() {
    if(IncrementButtons) {
      IB.updateUI();
      DB.updateUI();
      IB.displayUI();
      DB.displayUI();
    }
  }

  //Activated when mousePressed() is called
  void listenPressed() {
    if(MouseIsOver()) {
      Pressed = true;
    }
    IB.listenPressed();
    DB.listenPressed();
  }

  //Activated when mouseReleased() is called
  void listenReleased() {
    if(Pressed) { onRelease(); }
    Pressed = false;
    IB.listenReleased();
    DB.listenReleased();
  }

  boolean MouseIsOver() {
    if(!vert) {
      if(mouseX + screenxshift <= absX()+l/2+(size*3+10)/2 && mouseX + screenxshift >= absX()-l/2-(size*3+10)/2
      && mouseY + screenyshift <= absY()+(size*3+10)/2 && mouseY + screenyshift >= absY()-(size*3+10)/2) {
        return true;
      }
    } else {
      if(mouseX + screenxshift <= absX()+(size*3+10)/2 && mouseX + screenxshift >= absX()-(size*3+10)/2
      && mouseY + screenyshift <= absY()+l/2+(size*3+10)/2 && mouseY + screenyshift >= absY()-l/2-(size*3+10)/2) {
        return true;
      }
    }
    return false;
  }

  //setX/Yshift are overwritten, since the Valuebox has its own x,y coordinates,
  //which are set in the Standard_Slider Constructor and x/yshift are set
  //after initialising the Standard_Slider in case its part of a Composite Object
  //Therefore when x/yshift are set, the ValueBox coordinates have to be updated as well
  @ Override
  void setXshift(float newxshift) {
    xshift = newxshift;
    if(!vert) {
      VB.setX(absX()-l/2+(CurVal-min)*step);
    } else {
      VB.setX(absX()+size*2.5+35);
    }
    IB.setXshift(newxshift);
    DB.setXshift(newxshift);
  }
  @ Override
  void setYshift(float newyshift) {
    yshift = newyshift;
    if(!vert) {
      VB.setY(absY()+size*2+25);
    } else {
      VB.setY(absY()+l/2-(CurVal-min)*step);
    }
    IB.setYshift(newyshift);
    DB.setYshift(newyshift);
  }

  //Set decimal places to be displayed
  void setdc(int newdc) { dc = newdc; }
}
