import g4p_controls.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;

image_loader i_h;

void setup() {
  size(730,800);
  surface.setResizable(true);
  i_h = new image_loader("buddha.jpg");
  i_h.load_all_image_data();
  
  createGUI();
  
  imageData.setText(i_h.get_image_data());
  

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
