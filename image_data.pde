class image_data {
  //the entire image loaded into this byte array
  byte[] image_bytes;
  //the entire image converted into hexadecimal
  StringList image_hex;
  
  //stores the index at which the quantization tables appears
  IntList quant_tables_index = new IntList();
  
  String path;
  
  int curr_table;
  
  //constant variables for code logic
  final boolean first_time = true;
  final boolean other_times = false;
  
  image_data(String p) {
    path = p;
    curr_table = 0;
  }

  //fills image_bytes and image_hex
  void load_image_data() {
    image_bytes = loadBytes(path + dot_jpg);
    image_hex = new StringList();
    set_image_hex(first_time);
    find_quant_tables();
  }
  
  //convert image_bytes to hexadecimal and put the elements in image_hex
  void set_image_hex(boolean is_first_time) {
    if(is_first_time == true) {
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
      //FF and DB in tandem signifies the start of a quantization table 
      //see: https://en.wikipedia.org/wiki/JPEG#Syntax_and_structure
      if (image_hex.get(i).equals("FF") && image_hex.get(i + 1).equals("DB")) {
        quant_tables_index.append(i);
      }
    }
  }
  
  //get one of two quantization tables based on n
  String get_quant_tables(int n) {
    int index = quant_tables_index.get(n);
    String quant_tables = "";
    for(int i = index + 5; i < index + 69; ++i) {
      quant_tables += image_hex.get(i) + " ";
    }
    return quant_tables;
  }
  
  StringList get_quant_tables_array(int n) {
    int index = quant_tables_index.get(n);
    StringList quant_tables = new StringList();
    for(int i = index + 5; i < index + 69; ++i) {
      quant_tables.append(image_hex.get(i));
    }
    return quant_tables;
  } 
  
  //runs everytime image data is edited on the user side
  void alter_image_data(String new_image_data) {
    
    String[] l = split(new_image_data, ' ');
    byte[] possible_new_image_bytes = check_data_validity(l, quant_tables_index.get(curr_table));
    //if all data is vaild hexadecimal numbers
    if(possible_new_image_bytes.length > 0) {
      arrayCopy(possible_new_image_bytes, image_bytes);
      set_image_hex(other_times);
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
      //let user know the vaildity of their data
      label1.setText("Data:\n Input Good");
      return new_image_bytes;
    }
    catch (Exception e) {
      label1.setText("Data:\n Input Not Vaild");
      return new byte[0];
    }
  }
  
  //using intlist for convenience
  IntList to_byte_array(StringList hex_arr) {
    IntList new_list = new IntList();
    for(int i = 0; i < hex_arr.size(); ++i) {
      new_list.append(unhex(hex_arr.get(i)));
    }
    return new_list;
  }
  
  StringList to_hex_array(IntList byte_arr) {
    StringList hex_arr = new StringList();
    for(int i = 0; i < byte_arr.size(); ++i) {
      hex_arr.append(hex(byte_arr.get(i),2));
    }
    return hex_arr;
  }
  
  void get_next_table() {
    //quant_tables_index.size() is the number of tables in the jpeg image
    if(curr_table + 1 < quant_tables_index.size()) {
      curr_table++;
      imageData.setText(get_quant_tables(curr_table));
    }
  }
  
  void get_prev_table() {
    if(curr_table - 1 >= 0) {
      curr_table--;
      imageData.setText(get_quant_tables(curr_table));
    }
  }
  
  //Q is Q Factor
  void set_quality(int Q) {
    int S = 0;
    
    //Quantization table calculation method by Independent JPEG Group(IJG)
    if(Q < 50) {
      S = 5000/Q;
    } else {
      S = 200 - 2*Q;
    }
    
    IntList byte_arr = to_byte_array(get_quant_tables_array(0));
    for(int i = 0; i < byte_arr.size(); ++i) {
      int curr = byte_arr.get(i);
      int val = floor((S * curr + 50) / 100);
      if(val == 0) {
        val = 1;
      } else if(val > 255) {
        val = 255;
      }
      byte_arr.set(i, val); 
    }
    
    StringList hex_arr = to_hex_array(byte_arr);
    
    String str_hex_arr = "";
    for(int i = 0; i < hex_arr.size(); ++i) {
      str_hex_arr += hex_arr.get(i) + " ";
    }
    imageData.setText(str_hex_arr);
    alter_image_data(str_hex_arr);
    
  }
  
}
