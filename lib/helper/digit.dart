String digit0 = """
#########
#########
###   ###
###   ###
###   ###
###   ###
###   ###
#########
#########
"""
    .replaceAll("\n", "");

String digit1 = """
     #   
   ###   
  ####   
######   
   ###   
   ###   
   ###   
   ###   
#########
"""
    .replaceAll("\n", "");

String digit2 = """
   ###   
#########
###   ###
      ###
      ###
    ###  
  ###    
#########
#########
"""
    .replaceAll("\n", "");

String digit3 = """
   ###   
#########
###   ###
     ### 
    ###  
     ### 
###   ###
#########
   ###   
"""
    .replaceAll("\n", "");

String digit4 = """
     ####
    #####
   ## ###
  ##  ###
 ##   ###
#########
      ###
      ###
      ###
"""
    .replaceAll("\n", "");

String digit5 = """
#########
###      
###      
#######  
    #####
      ###
      ###
###   ###
  #####  
"""
    .replaceAll("\n", "");

String digit6 = """
  ###### 
###      
###      
###      
######## 
###   ###
###   ###
###   ###
 ####### 
"""
    .replaceAll("\n", "");

String digit7 = """
#########
#########
      ###
     ### 
    ###  
   ###   
  ###    
 ###     
###      
"""
    .replaceAll("\n", "");

String digit8 = """
  #####  
###   ###
###   ###
###   ###
 ####### 
###   ###
###   ###
###   ###
  #####  
"""
    .replaceAll("\n", "");

String digit9 = """
  #####  
###   ###
###   ###
###   ###
  #######
      ###
     ### 
    ###  
 ####    
"""
    .replaceAll("\n", "");

String switchTime(String digit) {
  switch (digit) {
    case "0":
      return digit0;
    case "1":
      return digit1;
    case "2":
      return digit2;
    case "3":
      return digit3;
    case "4":
      return digit4;
    case "5":
      return digit5;
    case "6":
      return digit6;
    case "7":
      return digit7;
    case "8":
      return digit8;
    case "9":
      return digit9;
  }
  return null;
}
