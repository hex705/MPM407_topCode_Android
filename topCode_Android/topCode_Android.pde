
// this version works -- jan 8, 2013
// based on Scanner change from D. Bouchard
// keep image smaller if you can and lower frame rate

// there is a memory limit on apps -- cameras can eat alot of memory


import android.graphics.Bitmap.*;
import ketai.camera.*;

KetaiCamera cam;
import java.util.List; 

List<TopCode> codes;
Scanner scanner; // top code scanner


void setup() {

  orientation(LANDSCAPE);
  cam = new KetaiCamera(this,640, 480, 30);
  println(cam.list()); //(1)
  // 0: back camera; 1: front camera
  cam.setCameraID(0); //(2)
  imageMode(CENTER);
  stroke(255);
  textSize(24); //(3)
 
   frameRate(10);
  scanner = new Scanner();
}

void draw() {

   
  
    // we need a copy of the pixels array
    // because the scanner modifies the image it is given
  
              background(0); // hide the errant tags
              image(cam,width/2,height/2);
             
                    int[] pixels = new int[cam.pixels.length];
                    System.arraycopy(cam.pixels, 0, pixels, 0, cam.pixels.length);
                
                   //List<TopCode> codes = null;
                 codes = null;
                    codes = scanner.scan(pixels, cam.width, cam.height);
                    
                    println(" new codes " + codes.size());
                    
              
              // next line is a way to grab raw 
              // PImage otherImage = getAsImage();
             
              // draw the image for reference
              //image(cam, 0, 0);  // was cam 
          
          
              // draw the codes (if any)
              rectMode(CENTER);
              stroke(0, 255, 0);
              noFill();
              for (TopCode code : codes) {
                // int scaledX, scaledY;
                 pushMatrix();
                     // check to see if the camera is smaller than screen 
                     // if it is we need to translate the x,y of the code tag.
                     //  full screen on my device is very SLOW
                     if ( displayWidth != cam.width || displayHeight != cam.height) {
                             int left = (displayWidth - cam.width ) / 2;
                             int top = (displayHeight - cam.height ) / 2;
                             translate(left,top);
                     }
                     translate(code.getCenterX(), code.getCenterY());
                     text(code.getCode(), 0, 0);
                     rotate(code.getOrientation());
                     rect(0, 0, code.getDiameter(), code.getDiameter());
                 popMatrix();
                // println(code.getCode());
              }
  
  }



//
//// following is a buffered image converter -- from processing forum
////http://forum.processing.org/topic/converting-bufferedimage-to-pimage
////http://forum.processing.org/#Topic/25080000000459084
//
//PImage getAsImage() {
//    
//      try {
//       //  ByteArrayInputStream bis= new ByteArrayInputStream(bytes); 
//       //  BufferedImage bimg = ImageIO.read(bis); 
//        BufferedImage bimg =  scanner.getImage();
//        PImage img=new PImage(bimg.getWidth(),bimg.getHeight(),PConstants.ARGB);
//        bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
//        img.updatePixels();
//        return img;
//      }
//      catch(Exception e) {
//        System.err.println("Can't create image from buffer");
//        e.printStackTrace();
//      }
//      return null;
//    }
//  
//

void mouseReleased() {
   if (cam.isStarted())
      {
        cam.stop();
      }
      else
      {
         cam.start();
        if (!cam.start())
          println("Failed to start camera.");
      }
  
}


void onCameraPreviewEvent()
{
  cam.read();
}

void exit()
{
  cam.stop();
}

