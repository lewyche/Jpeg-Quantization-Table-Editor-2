String quant_mode = "0";

class image_loader {
  
  PImage curr_image;
  
  String curr_image_path;
  
  image_data id;
  
  image_loader(String path) {
    this.curr_image_path = path;
    
    //set up image_data
    id = new image_data(curr_image_path);
    //setup image to be displayed to screen
    curr_image = loadImage(path + dot_jpg);
  }
  
  void load_all_image_data() {
    id.load_image_data();
  }
  
  void change_image_data(String data) {
    id.alter_image_data(data);
  }
  
  void set_curr_image(String path) {
    curr_image_path = path;
    curr_image = loadImage(path + dot_jpg);
  }
  
  String get_image_data() {
    return id.get_quant_tables(0);
  }
  
  void save_image_data() {
    BufferedImage bi = toBufferedImage(id.image_bytes);
    try {
      //Using java.io, wants absolute path
      String new_image_path = curr_image_path + "(1)";
      File fileout = new File(sketchPath() + "/" + new_image_path + dot_jpg);
      ImageIO.write(bi, "jpg", fileout);
      set_curr_image(new_image_path);
    } catch(IOException e) {
      println("write didn't work buddy");
    }
  }
  
  void draw_image() {
    image(curr_image, 0, 0);
  }
  
}
