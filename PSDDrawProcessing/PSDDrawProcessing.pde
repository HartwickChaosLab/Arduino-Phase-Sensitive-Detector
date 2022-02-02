// {PSDDrawProcessing.}
//    Copyright (C) {2014}  Kevin D. Schultz
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.

/*
 Modifyed by FLE 20220130
 Make ADC input for ADC2 for OctoUNO hardware.  Useing A2.
 Move graphing into draw()
 
 Got good ideas from:https://discourse.processing.org/t/how-to-solve-disabling-serialevent-for-com3-null/10214/4
 Fix error of type: Disabling serialEvent for COMn null”
 Move from serial event handler to main loop these lines
 mix = int(split(myString, ','));     // split the string at the commas // and convert the sections into integers:
 PSD(choice);        //Draw the PSD
 
 Change sin cos look up table for single range of 2 Pi
 20220201 Input from Arduino is now mV. So lets rescale the display
 */

import processing.serial.*;

String COMPANY = " ";
String MODELNAME = "PSD";
String VERSION = "2.0.0";  //Different enough from Kevin D. Schultz original to warrant V2.x.x.x

//float TC=200.0;
//float TC=100.0;
//float TC=50.0;
//float TC=5.0;
float TC=1.0;

//Exponetinal moveing average 
float x=exp(-1/TC);
float a=1-x;
float b=x;
float filter_out = 0;
float old_filter=0;// the value from the sensor

float I_filter_out;
float Q_filter_out;
float I_prev_filter;
float Q_prev_filter;

int linefeed = 10;      // linefeed in ASCII
Serial myPort;          // The serial port
int graphPosition = 0;  // the horizontal position of the latest
float prev_filter=0;                     // line to be drawn on the graph
int mix[];
float mix_I;
float mix_Q;

PFont f;
PFont myFont;

float phase;
int choice=0;

String myString ="";
boolean gotString = false;  //Flag for the serial event  
int totalNumber = 0;

int IQ_Zero = height/4;
int magnatudeZero = height/2;
int phaseZero = height*3/4;


void setup() {
  //  size(512, 256);
  size(1024, 800); //FLE
  surface.setTitle(COMPANY + ", " + MODELNAME + " Display, Version: " + VERSION);
  IQ_Zero = height/4;
  magnatudeZero = height/2;
  phaseZero = height*3/4;
  filter_out = magnatudeZero; //Start at zero line.

  background(0);
  stroke(0, 255, 100);    //Line color
  // List all the available serial ports
  printArray(Serial.list());
  f = createFont("Arial", 16, true);

  // I know that the first port in the serial list on my Mac
  // is always my  Arduino, so I open Serial.list()[4].
  // Open whatever port is the one you're using (the output
  // of Serial.list() can help; the are listed in order
  // starting with the one that corresponds to [4]).
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  //myPort=new Serial(this, Serial.list()[6], 19200);
  //myPort=new Serial(this, Serial.list()[6], 38400);
  //  myPort=new Serial(this, Serial.list()[5],115200);        //FLE Make Faster
  myPort=new Serial(this, Serial.list()[6], 115200);        //FLE Make Faster
  //myPort=new Serial(this, Serial.list()[7],115200);        //FLE Make Faster
  myPort.bufferUntil('\n');
  delay(2000);          //Delay before sending character to start UNO aquiring data. Impericaly determined.
  myPort.write("A"); //Tell Arduino UNO to start aquizition.
}// end setup()

void draw() {
  if (gotString == true) {
    totalNumber++;
    mix = int(split(myString, ','));     // split the string at the commas // and convert the sections into integers:
    PSD(choice);        //Draw the PSD
  }

  //line(graphPosition-1, prev_filter, graphPosition, filter_out);
}



//Draw the PSD to the window.
void PSD(int option) {

  drawGraph();//Draw the axis

  x=exp(-1/TC); //ToDo identify, What are the units of TC???
  a=1-x;
  b=x;

  //Expected range of I and Q from Arduion in mV.
  float maxMIX = +2500;
  float minMIX = -2500;

  //Scale for about 1/4 of screen hight
  mix_I = map(mix[0], minMIX, maxMIX, -height/4, height/4);
  mix_Q = map(mix[1], minMIX, maxMIX, -height/4, height/4);
  print("N= " + totalNumber + ", mix[0]=" + mix[0]);  
  print(" mix[1]=" + mix[1]);
  print(", mixI=" + mix_I);  
  println(", mixQ=" + mix_Q);
  
  I_prev_filter = I_filter_out;
  Q_prev_filter = Q_filter_out;     
  I_filter_out = a * mix_I + b * I_prev_filter;
  Q_filter_out = a * mix_Q + b * Q_prev_filter;

  switch(option) {
  case 0: //Magnatude
    prev_filter = filter_out;
    //I_prev_filter = I_filter_out;
    //Q_prev_filter = Q_filter_out;     
    //I_filter_out = a*mix_I + b*I_prev_filter;
    //Q_filter_out = a*mix_Q + b*Q_prev_filter;
    filter_out= sqrt(I_filter_out * I_filter_out + Q_filter_out * Q_filter_out);  //Magnitude Offset to center FLE 20220201
    //filter_out=180+ atan(Q_filter_out/I_filter_out)*360/6.42; //Offset by 180 degrees FLE 20220201
    //    println("mag");
    fill(0);
    noStroke();
    rect(0, 0, width/2, 20);
    textFont(f, 16);                 // STEP 4 Specify font to be used
    stroke(255, 100, 0);    //Line color Magnatude
    line(graphPosition-1, (magnatudeZero-prev_filter), graphPosition, (magnatudeZero -filter_out));
    fill(156);                        // STEP 5 Specify font color 
    text("Magnitude="+(filter_out), 10, 20);
    break;

  case 1: //Inphase signal
    prev_filter=filter_out;
    filter_out = a*mix_I + b*prev_filter;
    //    println("in phase");
    fill(0);
    noStroke();
    rect(0, 0, width, 20);
    textFont(f, 16);                 // STEP 4 Specify font to be used
    fill(156);                         // STEP 5 Specify font color 
    text("I="+ filter_out, 10, 20);
    stroke(0, 100, 255);     //Line color Inphase
    line(graphPosition-1, (IQ_Zero - prev_filter), graphPosition, (IQ_Zero - filter_out));
    break;

  case 2: //Quadrature signal
    prev_filter=filter_out;
    filter_out= a*mix_Q + b*prev_filter;
    //    println("Quadature");
    fill(0);
    noStroke();
    rect(0, 0, width, 20);
    textFont(f, 16);                 // STEP 4 Specify font to be used
    fill(156);                         // STEP 5 Specify font color 
    text("Q="+ (filter_out-IQ_Zero), 10, 20);
    stroke(0, 255, 100);    //Line color Quadrature    
    line(graphPosition-1, (IQ_Zero - prev_filter), graphPosition, (IQ_Zero - filter_out));
    break;

  case 3: //Phase
    prev_filter=filter_out;
    //I_prev_filter = I_filter_out;
    //Q_prev_filter = Q_filter_out;     
    //I_filter_out = a * mix_I + b * I_prev_filter;
    //Q_filter_out = a * mix_Q + b * Q_prev_filter;
    filter_out = phaseZero + atan(Q_filter_out/I_filter_out)*360/6.42; //Offset by 180 degrees FLE 20220201
    //   println("phase= "+filter_out);
    fill(0);
    noStroke();
    rect(0, 0, width, 20);
    textFont(f, 16);                 // STEP 4 Specify font to be used
    fill(156);                         // STEP 5 Specify font color 
    text("phase="+ (filter_out- phaseZero), 10, 20);
    stroke(100, 255, 0);    //Line color Phase
    line(graphPosition-1, prev_filter, graphPosition, filter_out);
    break;
  }//end switch optins on keyboard input. 
  //  myPort.write("A"); //Tell Arduino UNO to start another aquizition.
  // println(filter_out);
}// end PSD()

/*Graph the data*/
void drawGraph() {
  //Print timie constant
  fill(0);
  noStroke();
  rect(0, 0, width/8, 40);
  fill(156);                        // STEP 5 Specify font color 
  text("TC= " + (TC), 10, 40);
  smooth();
  fill(20);
  //  stroke(0, 255, 100);    //Line color
  strokeWeight(2);

  //Draw zero lines for IQ, Mag, and Phase
  stroke(255);    //Axis color I/Q
  line(0, IQ_Zero, width, IQ_Zero);
  stroke(255, 100, 0);    //Line color Magnatude
  line(0, magnatudeZero, width, magnatudeZero);
  stroke(100, 255, 0);    //Line color Phase
  line(0, phaseZero, width, phaseZero);

  if (graphPosition>=width)
  {
    graphPosition=0;
    //    background(0);      //FLE lets not erase.
  } else {
    graphPosition++;
  }
}//end drawGraph()
