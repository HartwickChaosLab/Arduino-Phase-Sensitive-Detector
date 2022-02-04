/*Get user input from keyboard and mouse
 Copyright (C) {2014}  Kevin D. Schultz
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
 Broken into tabs 20220130.
 Add X to increase TC by ten. Add R to reset time constant.
 Add L and U command to lock and unlock oscillator 20220202
 
 */


/*  Key  Action
 z    decress TC
 x    increase TC one
 X    increase TC by ten
 r    reset TC to one
 i    Inphase
 m    Magnatude
 p    Phase
 q    Quadrature
 l    Lock
 u    unlock
 a    Start data from UNO
 
 */

void keyReleased()
{
  //println("key: "+key+" keyCode: "+keyCode);  //For key development

  if (key=='a'||key=='A')
  {
    //Send data
    myPort.write("A"); //Tell Arduino UNO to start another aquizition.
  }
    if (key=='l'||key=='L')
  {
    //Lock to phase
    myPort.write("L"); //Tell Arduino UNO to lock to phase
  }
    if (key=='u'||key=='U')
  {
    //Unlock oscillator 
    myPort.write("U"); //Tell Arduino UNO to unlock the oscillator
  }
  if (key=='z'||key=='Z')
  {
    TC--;
    println(TC);
  }
  if (key=='r'||key=='R')
  {
    TC =0;
    println(TC);
  }

  if (key=='X')
  {
    TC++;
    println(TC);
  }
  if (key=='X')
  {
    TC += 10;
    println(TC);
  }
  if (key=='i'||key=='I')
  {
    choice=1;
  }
  if (key=='m'||key=='M')
  {
    choice=0;
  }
  if (key=='p'||key=='P')
  {
    choice=3;
  }
  if (key=='q'||key=='Q')
  {
    choice=2;
  }
  if (key==' ')
  {
    background(0);
    graphPosition=0;
  }
}// end keyrelease() 




void mousePressed()
{
  if (mouseButton == LEFT) {  
    println("Left pressed.");
  } else if (mouseButton == RIGHT) {
    background(0);      //FLE lets not erase.
    graphPosition=0;
    println("Right pressed.");
  } else if (mouseButton == CENTER) {
    println("Center pressed.  Making Snap.png.\n");
    saveFrame("Snap.png");
  } else {  
    println("Mouse but no button.\n");
    // No action
  }
}// end mouserPressed()
