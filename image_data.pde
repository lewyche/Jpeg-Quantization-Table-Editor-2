class image_data {
  //the entire image loaded into this byte array
  byte[] image_bytes;
  //the entire image converted into hexadecimal
  StringList image_hex;

  //part of the image data that will be displayed to the screen
  String image_display_data;

  //stores the index at which the quantization table appears
  IntList quant_tables_index = new IntList();
  
  String path;
  image_data(String p) {
    path = p;
  }

  //fills image_bytes and image_hex
  void load_image_data() {
    image_bytes = loadBytes(path);
    image_hex = new StringList();
    set_image_hex(true);
    find_quant_tables();
  }
  
  //TODO: change name to make parameters make more sense
  //EG: set_image_hex(true); does not reflect the function of this function
  void set_image_hex(boolean first_time) {
    if(first_time == true) {
      for (int i = 0; i < image_bytes.length; i++) {
        int a = image_bytes[i] & 0xff;
        image_hex.append(hex(a, 2));
      }
    } else {
      for (int i = 0; i < image_bytes.length; i++) {
        int a = image_bytes[i] & 0xff;
        image_hex.set(i, hex(a, 2));
      }
    }
  }

  //fills quant_tables_index
  void find_quant_tables() {
    for (int i = 0; i < image_hex.size(); ++i) {
      if (image_hex.get(i).equals("FF") && image_hex.get(i + 1).equals("DB")) {
        quant_tables_index.append(i);
      }
    }
  }
  
  String get_quant_tables(int n) {
    int index = quant_tables_index.get(n);
    String quant_tables = "";
    for(int i = index + 5; i < index + 69; ++i) {
      quant_tables += image_hex.get(i) + " ";
    }
    return quant_tables;
  }
  
  //runs everytime image data is edited on the user side
  void alter_image_data(String new_image_data) {
    String[] l = split(new_image_data, ' ');
    byte[] possible_new_image_bytes = check_data_validity(l, quant_tables_index.get(0));
    if(possible_new_image_bytes.length > 0) {
      arrayCopy(possible_new_image_bytes, image_bytes);
      set_image_hex(false);
    }
    
  }
  
  //check if user entered data are valid hexadecimal numbers
  byte[] check_data_validity(String[] data, int index) {
    //will throw exeception if data[i] is not a vaild hexadecimal number
    try {
      byte[] new_image_bytes = image_bytes.clone();
      for(int i = index + 5; i < index + 69; ++i) {
        new_image_bytes[i] = byte(unhex(trim(data[i - (index + 5)])));
      }
      return new_image_bytes;
    }
    catch (Exception e) {
      println("erm not vaild");
      return new byte[0];
    }
  }
}
