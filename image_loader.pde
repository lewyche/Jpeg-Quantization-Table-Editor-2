String quant_mode = "0";

class image_loader {
  
  PImage curr_image;
  
  String curr_image_path;
  
  image_data id;
  
  image_loader(String path) {
    this.curr_image_path = path;
    id = new image_data(path);
    curr_image = loadImage(path);
  }
  
  void load_all_image_data() {
    id.load_image_data();
  }
  
  void change_image_data(String data) {
    id.alter_image_data(data);
  }
  
  String get_image_data() {
    return id.get_quant_tables(0);
  }
  
  void save_image_data() {
    println("penis");
    BufferedImage bi = toBufferedImage(id.image_bytes);
    File fileout = new File("D:/Projects/Coding Projects/Processing Projects/jpeg_editor/buddha.jpg");
    try {
      ImageIO.write(bi, "jpg", fileout);  
    } catch(IOException e) {
      println("write didn't work buddy");
    }
  }
  
  void draw_image() {
    image(curr_image, 0, 0);
  }
  
}
