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

*/


/*  Key  Action
 z    decress TC
 x    increase TC
 i    Inphase
 m    Magnatude
 p    Phase
 q    Quadrature
 
 */

void keyReleased()
{
  if (key=='z'||key=='Z')
  {
    TC--;
    println(TC);
  }
  if (key=='x'||key=='X')
  {
    TC++;
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
}// end keyrelease() 




void mousePressed()
{
  saveFrame("Snap.png");
  if (mouseButton == LEFT) {  
    println("Left pressed.");
  } else if (mouseButton == RIGHT) {
    background(0);      //FLE lets not erase.
    graphPosition=0;
    println("Right pressed.");
  } else if (mouseButton == CENTER) {
    println("Center pressed.\n");    
  } else {  
    println("Mouse but no button.\n");
    // No action
  }
}// end mouserPressed()
