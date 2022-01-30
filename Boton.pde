class Button{
  int posx;
  int posy;
  int numero;
  float ancho;
  float ancho2;
  float largo;
  float largo2;
  float textSize;
  String texto;
  color colorBoton;
  color stroke;
  boolean botonActivo;
  boolean grafo;
  
  Button(int x, int y, String txt,int anc,int lar){
    posx=int(x*proportion);
    posy=int(y*proportion);
    texto=txt;
    colorBoton=color(255);
    ancho=proportion*anc;
    ancho2=ancho;
    largo=proportion*lar;
    largo2=largo;
    textSize=proportion*3;
  }
  Button(int num,int anc,int lar){
    if(num%5==0){
      posx=int(proportion*17*5);
      posy=int(proportion*22+((num/5)-1)*proportion*15);
    }
    else{
      posx=int(num%5*proportion*17);
      posy=int(proportion*22+(num-num%5)*proportion*3);
    }
    colorBoton=color(255);
    ancho=proportion*anc;
    ancho2=ancho;
    largo=proportion*lar;
    largo2=largo;
    textSize=proportion*4;
    grafo=true;
    numero=num;
  }
  
  void draw(boolean activo){
    push();
    if(activo==false){
      botonActivo=false;
      colorBoton=color(100);
      stroke=color(80);
    }
    else{
      botonActivo=true;
      stroke=colorNodo2;
      colorBoton=color(255);
    }
    
    rectMode(CENTER);
    strokeWeight(proportion);
    
    if(grafo){
      stroke(15,15,15,180);
      rect(posx+proportion*0.1,posy+proportion*0.1,ancho,largo,8);
      
      stroke(stroke);
      fill(colorBoton);
      rect(posx,posy,ancho,largo,8);
      
      textAlign(CENTER,CENTER);textSize(textSize); 
      fill(stroke); text(str(numero),posx,posy);
    }
    else {
      stroke(15,15,15,180);
      rect(posx+proportion*0.1,posy+proportion*0.1,ancho,largo,8);
      
      stroke(stroke);
      fill(colorBoton);
      rect(posx,posy,ancho,largo,8);
      
      textAlign(CENTER,CENTER);textSize(textSize); 
      fill(stroke); text(texto,posx,posy);
    }
      pop();
  }
  
  boolean above(){
    if  (mouseX>posx-ancho/2 && mouseY>posy-largo/2
      && mouseX<posx+ancho/2 && mouseY<posy+largo/2 && botonActivo){
      dentro_boton=true;
      return true;
    }
    else {
      return false;
    }
  }
  void cambiar(boolean aboveButton){

    if(aboveButton && botonActivo){
      ancho=ancho2+proportion*0.7;
      largo=largo2+proportion*0.7;
      textSize=proportion*3.3;
    }
    else{
      ancho=ancho2;
      largo=largo2;
      textSize=proportion*3;
    }
  }
  void inactivo(){
    botonActivo=false;
  }
  void activo(){
   botonActivo=true;
  }
}
