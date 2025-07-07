Interface I;
boolean debug = false;
boolean pause = false;
boolean render = true;
boolean uncappedFrameRate = false;

boolean tierinfo_display_activations = true; // true: display activations, false: display weights

char last_key = 'µ';

void setup() {
  fullScreen();
  smooth();
  frameRate(30);
  I = new Interface();
}



void draw() {
  //print(round(frameRate)," ");
  //print("\nwidth: "+width+"\nheight: "+height);
  if(!keyPressed) {
    last_key = 'µ';
  }
  I.show();
  //println(int(-1.6));
}

void mouseClicked() {

}

void mousePressed() {
  for(UI_Element ui_element : I.screens.get(I.screen).ui_elements) {
    ui_element.listenPressed();
  }
  if(I.screen == 0) {
    I.P.T.select(mouseX, mouseY);
  }
}

void mouseReleased() {
  for(UI_Element ui_element : I.screens.get(I.screen).ui_elements) {
    ui_element.listenReleased();
  }
}

void keyPressed() {
  if(I.screen == 0) {                      //Ermittelt gedrückte Tasten und sorgt für deren Funktionalität
    if(key == 'd' || last_key == 'd') {
      I.P.TLX = constrain(I.P.TLX+1*I.P.Z,width/2,I.P.W.Aw*I.P.Z-width/2);       //X-Achsen scrolling  //0.8
      I.P.TLX0 = constrain(I.P.TLX0+1*I.P.Z,0,I.P.W.Aw*I.P.Z-width);
    } else if(key == 'a' || last_key == 'a') {
      I.P.TLX = constrain(I.P.TLX-1*I.P.Z,width/2,I.P.W.Aw*I.P.Z-width/2);
      I.P.TLX0 = constrain(I.P.TLX0-1*I.P.Z,0,I.P.W.Aw*I.P.Z-width);
    }

    if(key == 's' || last_key == 's') {
      I.P.TLY = constrain(I.P.TLY+1*I.P.Z,height/2,I.P.W.Aw*I.P.Z-height/2);      //Y-Achsen scrolling  //0.8
      I.P.TLY0 = constrain(I.P.TLY0+1*I.P.Z,0,I.P.W.Aw*I.P.Z-height);
    } else if(key == 'w' || last_key == 'w') {
      I.P.TLY = constrain(I.P.TLY-1*I.P.Z,height/2,I.P.W.Aw*I.P.Z-height/2);
      I.P.TLY0 = constrain(I.P.TLY0-1*I.P.Z,0,I.P.W.Aw*I.P.Z-height);
    }

    if(key == 'q' && I.P.Z < 40) {                                        //reinzoomen
      I.P.Z = constrain(I.P.Z+1,ceil(width/I.P.W.Aw),40);
      I.P.TLX = map(I.P.TLX, 0,I.P.W.Aw*(I.P.Z-1), 0,I.P.W.Aw*I.P.Z);
      I.P.TLY = map(I.P.TLY, 0,I.P.W.Aw*(I.P.Z-1), 0,I.P.W.Aw*I.P.Z);
      I.P.TLX0 = constrain(I.P.TLX-width/2,0,I.P.W.Aw*I.P.Z-width);
      I.P.TLY0 = constrain(I.P.TLY-height/2,0,I.P.W.Aw*I.P.Z-height);

    } else if(key == 'e' && I.P.Z > ceil(float(width)/float(I.P.W.Aw))) {                //herauszoomen
      I.P.Z = constrain(I.P.Z-1,ceil(float(width)/float(I.P.W.Aw)),40);                                                                                                                                                                                                              //solved
      I.P.TLX = constrain(map(I.P.TLX, 0,I.P.W.Aw*(I.P.Z+1), 0,I.P.W.Aw*I.P.Z),     width/2,I.P.W.Aw*I.P.Z-width/2);
      I.P.TLY = constrain(map(I.P.TLY, 0,I.P.W.Aw*(I.P.Z+1), 0,I.P.W.Aw*I.P.Z),     height/2,I.P.W.Aw*I.P.Z-height/2);
      I.P.TLX0 = constrain(I.P.TLX-width/2,0,I.P.W.Aw*I.P.Z-width);
      I.P.TLY0 = constrain(I.P.TLY-height/2,0,I.P.W.Aw*I.P.Z-height);
    }

    if(key == ' '){
      pause = !pause;
    }

    if(key == 'p'){
      debug = !debug;
    }

    if(key == 'u'){
      if(uncappedFrameRate){
        frameRate(30);
      } else {
        frameRate(200);
      }
      uncappedFrameRate = !uncappedFrameRate;
    }
    
    if(key == 'ä'){
      tierinfo_display_activations = !tierinfo_display_activations;
    }

    if(key == 'ü'){
      I.P.TI.deselect();
    }

    if(key == '´'){
      render = !render;
    }

    if(key == 'r'){
      I.P.T.spawn(I.P.Awdec * I.P.Awdec / 5);
    }
  } else if(I.screen == 1) {

  } else if(I.screen == 2) {

  } else if(I.screen == 3) {

  } else if(I.screen == 4) {

  }

  if(last_key == 'µ') {
    last_key = key;
  }
}

void keyReleased() {
  if(key == last_key) {
    last_key = 'µ';
  }
}
