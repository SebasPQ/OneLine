class Node {
  float _x;
  float _y;
  int _radius;
  int aristas_conectadas;
  color _stroke;
  

 Node(int x, int y) {
    _x = x*proportion;
    _y = y*proportion;
    _radius = int(proportion*2.4);
    _stroke = colorNodo;
  }
 Node(float x, float y) {
   _x = x;
   _y = y;
   _radius = int(proportion*2.4);
   _stroke = colorNodo;
 }

  void draw() {
    push();
    strokeWeight(_radius);
    
    stroke(15,15,15,180);
    fill(15,15,15,180);
    circle(_x+proportion*0.1, _y+proportion*0.1,_radius);
    
    stroke(_stroke);
    fill(_stroke);
    circle(_x, _y,_radius);
    pop();
  }
  void cambiarColor(color color_nodo){
  _stroke=color_nodo;
  }
 
  boolean inside() {
    if  (sqrt(sq(_x-mouseX) + sq(_y-mouseY)) < _radius 
      && sqrt(sq(_x-mouseX) + sq(_y-mouseY)) < _radius){
      return true;
    }
    else {
      return false;
    }
  }
  
  void reiniciar(){
    _stroke=colorNodo;
  }
  float getX(){
    return _x;
  }
  float getY(){
    return _y;
  }
  void aumentar_aristas(){
    aristas_conectadas++;
  }
  void reducir_aristas(){
    aristas_conectadas--;
  }
}
