/* --------------------------------------------------------------------------
 * SimpleOpenNI DepthImage Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
import s373.flob.*;

SimpleOpenNI  context;


PImage vrImage;
int videores=128;//64//256
Flob flob;


void setup()
{
  context = new SimpleOpenNI(this);
   
  // mirror is by default enabled
  context.setMirror(true);
  
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable ir generation
  //context.enableRGB(640,480,30);
  //context.enableRGB(1280,1024,15);  
  if(context.enableRGB() == false)
  {
     println("Can't open the rgbMap, maybe the camera is not connected or there is no rgbSensor!"); 
     exit();
     return;
  }
 
  size(1280,520);
 
     // downscale image to ease flob processing load
  vrImage = createImage(videores, videores, RGB);
  //flob = new Flob(vrImage, this); 
   flob = new Flob(this, videores, videores, 640, 480);

  flob.setThresh(80).setSrcImage(3).setBackground(vrImage)
    .setBlur(0).setOm(1).setFade(25).setMirror(false, false);

  rectMode(CENTER);
  textFont(createFont("monospace",16));
  
 
 
  
}

void draw()
{
  // update the cam
  context.update();
  
    vrImage.copy(context.depthImage(), 0, 0, 640, 480, 0, 0, videores, videores);
    flob.calc(flob.binarize(vrImage));    
  image(flob.getSrcImage(), 0, 0, 640, 480);
   int numblobs = flob.getNumBlobs();  
  if (numblobs>0) {
    for (int i = 0; i < numblobs; i++) {
      ABlob ab = (ABlob)flob.getABlob(i); 
      //box
      fill(0, 0, 255, 100);
      rect(ab.cx, ab.cy, ab.dimx, ab.dimy);
      //centroid
      fill(0, 255, 0, 200);
      rect(ab.cx, ab.cy, 5, 5);
//      info = ""+ab.id+" "+ab.cx+" "+ab.cy;
//      text(info, ab.cx, ab.cy+20);
    }
  }
  
  //report presence graphically
  fill(255, 152, 255);
  rectMode(CORNER);
  rect(5, 5, flob.getPresencef()*width, 10);
  String stats = ""+frameRate+"\nflob.numblobs: "+numblobs+"\nflob.thresh:"+flob.getThresh()+
    " <t/T>"+"\nflob.fade:"+flob.getFade()+"   <f/F>"+"\nflob.om:"+flob.getOm()+
    "\nflob.image:"+flob.videotexmode+"\nflob.presence:"+flob.getPresencef();
  fill(0, 255, 0);
  text(stats, 5, 25);

  
  
  //background(200,0,0);
  
  // draw depthImageMap
 //image(context.depthImage(),640,0);
  
  // draw irImageMap
  //image(context.rgbImage(),context.depthWidth() + 10,0);
  image(context.depthImage(),640,495);
  
  
}
