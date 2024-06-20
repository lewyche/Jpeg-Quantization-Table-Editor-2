import g4p_controls.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;

// =================================================================
//                  IMPORTANT INFO READ ME!!!
//    TO EDIT YOUR OWN JPEG IMAGES, ADD THE IMAGE TO THE DIRECTORY
//    AND CHANGE THIS VARIABLE TO THE NAME OF YOUR IMAGE:
final String image_name = "cat";
//final String image_name = "lebron";
//    DO NOT INCLUDE ".jpg" AND DO NOT USE IMAGES OF A ANOTHER FORMAT
//    IMAGES MUST HAVE ".jpg" INSTEAD OF ".jpeg"
//    CONSIDER USING SMALLER IMAGES, BUT THE WINDOW IS RESIZEABLE
//    YOU WILL NOT BE ABLE TO OPEN THE IMAGES AFTER EDITING THEM
//    THIS PROGRAM WILL CREATE A NEW COPY OF YOUR IMAGE EVERY TIME YOU
//    PRESS THE SAVE BUTTON
// =================================================================


/*
                     User Tutorial
    This program allows you to edit the quantization tables of any jpeg.
    Quantization tables are traditionally displayed in 8x8 tables of 
    hexadecmial numbers, which is displayed in a seperate window, along
    with a save button. If all your edits are vaild(vaild hexadecimal numbers), pressing the save
    button will save your changes to a copy of your image, and display
    it on the window containing your image.
    
    Try replace the first hexadecimal number with "FF" and then press
    save.
*/

//Edit this if you want to enable or disable resizing
boolean resize_img = true;

image_loader i_h;

final String dot_jpg = ".jpg";

void setup() {
  size(730,800);
  surface.setResizable(true);
  i_h = new image_loader(image_name);
  i_h.load_all_image_data();
  
  createGUI();
  
  imageData.setText(i_h.get_image_data());
  if(i_h.i_d.quant_tables_index.size() <= 1) {
    next.setVisible(false);
    prev.setVisible(false);
  }
}

void draw() {
  fill(0,0,0);
  i_h.draw_image();
}

byte[] toByteArray(BufferedImage bi, String format) {
  byte[] return_bytes = {0};
  try{
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    ImageIO.write(bi, format, baos);
    byte[] bytes = baos.toByteArray();
    return bytes;
  } catch(Exception e) {
    return return_bytes;
  }

}

BufferedImage toBufferedImage(byte[] bytes) {

  try{
    
    InputStream is = new ByteArrayInputStream(bytes);
    BufferedImage bi = ImageIO.read(is);
    return bi;
  } catch(Exception e) {
    BufferedImage return_image = new BufferedImage(0,0,0);
    return return_image;
  }
}
