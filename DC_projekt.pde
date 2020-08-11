// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

boolean fid1Status = false;
boolean fid2Status = false;

void setup()
{
  // GUI setup
  noCursor();
  size(1680, 1050);
  noStroke();
  fill(0);

  // periodic updates
  if (!callback) {
    loop();
    frameRate(30);
  } else noLoop(); // or callback updates 

  font = createFont("Arial", 12);
  scale_factor = height/table_size;

  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw() {
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  drawBg();

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);
    noStroke();
    noFill();
    pushMatrix();
    translate(tobj.getScreenX(width), tobj.getScreenY(height));
    rotate(tobj.getAngle());
    rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
    popMatrix();
    fill(#e6e6e6);
    text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));

    if (tobj.getSymbolID() == 1) {                                                                            
      //println("sparegris medium");
      strokeWeight(2);
      stroke(#1e6885);
      noFill();
      rect(tobj.getScreenX(width)-100, tobj.getScreenY(height)-60, 290, 150, 100);                              //Dette er sparegris 1
      if (tobj.getScreenX(width)>1250 && tobj.getScreenX(width)<1590 && tobj.getScreenY(height)>100 && tobj.getScreenY(height)<300) {  
        fill(#a1da2f, 50);
        noStroke();
        rect(1250, 100, 340, 200, 100);   
        fill(#000000);
        textSize(50);
        text("200 kr.", 1350, 400);
        //if-sætning, farve sparegrisplads
        fid1Status = true;
      } else {
        fid1Status = false;
      }
    }

    if (tobj.getSymbolID() == 2) {                                                                           
      //println("kort 1");
      strokeWeight(3);
      stroke(#1e6885);
      noFill();
      rect(tobj.getScreenX(width)-100, tobj.getScreenY(height)-60, 290, 150, 50);                               //Dette er kort 1
      if (tobj.getScreenX(width)>300 && tobj.getScreenX(width)<640 && tobj.getScreenY(height)>100 && tobj.getScreenY(height)<300) {  
        fill(#a1da2f, 50);
        noStroke();
        rect(300, 100, 340, 200, 50);                                                                           //if-sætning, farve kortplads
        fill(#000000);
        textSize(50);
        text("350 kr.", 400, 400);
        fid2Status = true;
        if (fid1Status == true) {                                                  // If-sætning, denne spørger om fid1 er true(derefter bekræter den for fid2), 
          fill(#a1da2f);                                                           // HVIS de er det så laver den en farve i FÆLLES PLADS
          noStroke();
          ellipse(940, 200, 300, 300);
        }
      } else {
        fid2Status = false;
      }
    }

    if (tobj.getSymbolID()== 0) {                                                          // curser
      strokeWeight(3);
      stroke(#1e6885);
      noFill();
      ellipse(tobj.getScreenX(width), tobj.getScreenY(height), 70, 70);
      if (tobj.getScreenX(width)>0 && tobj.getScreenX(width)<200 && tobj.getScreenY(height)>300 && tobj.getScreenY(height)<360) { //
        fill(#1e6885);                                                                                    //ønskeknap feedback
        strokeWeight(2);
        stroke(#c21460);
        rect(20, 300, 160, 60, 20);

        fill(#c21460);
        text("ønsker", 50, 340);
      }

      if (tobj.getScreenX(width)>790 && tobj.getScreenX(width)<1090 && tobj.getScreenY(height)>650 && tobj.getScreenY(height)<950) {
        fill(#fccb1a);                                                                                   //ønske-plads feedback
        noStroke();
        ellipse(940, 800, 300, 300);
      }
    }
  }
  ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
  for (int i=0; i<tuioCursorList.size(); i++) {
    TuioCursor tcur = tuioCursorList.get(i);
    ArrayList<TuioPoint> pointList = tcur.getPath();

    if (pointList.size()>0) {
      stroke(0, 0, 255);
      TuioPoint start_point = pointList.get(0);
      for (int j=0; j<pointList.size(); j++) {
        TuioPoint end_point = pointList.get(j);
        line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));
        start_point = end_point;
      }
      stroke(64, 0, 64);
      fill(64, 0, 64);
      ellipse( tcur.getScreenX(width), tcur.getScreenY(height), cur_size, cur_size);
      fill(0);
      text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
    }
  }
  ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();
  for (int i=0; i<tuioBlobList.size(); i++) {
    TuioBlob tblb = tuioBlobList.get(i);
    stroke(64);
    fill(64);
    pushMatrix();
    translate(tblb.getScreenX(width), tblb.getScreenY(height));
    rotate(tblb.getAngle());
    ellipse(0, 0, tblb.getScreenWidth(width), tblb.getScreenHeight(height));
    popMatrix();
    fill(255);
    text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenY(height));
  }
}

void drawBg() {
  background(#ffffff);
  textFont(font, 12*scale_factor);

  fill(#d4edf7);
  noStroke();
  rect(0, 0, 200, height);                                                                             // menubar

  fill(#ffffff);
  ellipse(100, 100, 150, 150);                                                                        // brugerikon
  fill(#1e6885);
  ellipse(70, 70, 30, 30);
  ellipse(130, 70, 30, 30);
  bezier(50, 100, 100, 150, 125, 150, 150, 100);

  textSize(30);
  fill(#1e6885);
  text("John John", 25, 210);                                                                           //bruger

  fill(#ffffff);                                                                                       //sparegrisplads
  strokeWeight(2);
  stroke(#e6e6e6);
  rect(1250, 100, 340, 200, 100);

  fill(#ffffff);                                                                                       //kortplads
  strokeWeight(2);
  stroke(#e6e6e6);
  rect(300, 100, 340, 200, 50);

  fill(#ffffff);
  strokeWeight(2);
  stroke(#e6e6e6);
  ellipse(940, 200, 300, 300);                                                                    //fælles plads

  noFill();                                                                                // ønske-knap
  strokeWeight(2);
  stroke(#c21460);
  rect(20, 300, 160, 60, 20);

  fill(#c21460);
  text("ønsker", 50, 340);

  noFill();                                                                             //ønske-plads
  strokeWeight(2);
  stroke(#e6e6e6);
  ellipse(940, 800, 300, 300);

  noFill();
  strokeWeight(2);
  stroke(#c21460);
  rect(20, 950, 160, 60, 20);

  fill(#c21460);
  text("log ud", 60, 990);
}



// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
    +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}
