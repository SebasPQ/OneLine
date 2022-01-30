class Arista {
  float x1;
  float y1;
  float x2;
  float y2;
  int tipo;
  int grado;
  int gradoOriginal;
  float strokeWeight;
  color stroke=colorArista;
  
  Arista(Node node1, Node node2,int _tipo,int _grado){
    x1=node1._x;
    y1=node1._y;
    x2=node2._x;
    y2=node2._y;
    strokeWeight=2.3*proportion;
    tipo=_tipo;
    grado=_grado;
    gradoOriginal=grado;
  }
  
  void draw(){
    stroke(stroke);
    strokeWeight(strokeWeight);
    
    if (tipo==0){
      push();
      line(x1,y1,x2,y2);
      if(grado>0){
      flecha((((x2+x1)/2)+x1)/2,(((y2+y1)/2)+y1)/2,atan2((y2-y1), (x2-x1)));
      }
      pop();
    }
    else if(tipo==1){
      line(x1,y1,x2,y2);
    }
    else if(tipo==2){
      if(grado==0)
        line(x1,y1,x2,y2);
      else {
        push();
        stroke(colorArista);
        strokeWeight(strokeWeight);
        line(x1,y1,x2,y2);//
        
        if (grado!=gradoOriginal){
          stroke(color(colorR+50,colorG-50,colorB-50));
          strokeWeight(proportion*1.5);
          line(x1,y1,x2,y2);
          strokeWeight(2.2);fill(255);
          circle((x2+x1)/2,(y2+y1)/2,proportion*3.1);
          fill(0);textAlign(CENTER,CENTER);textSize(proportion*2.1);
          text(str(grado),(x2+x1)/2,(y2+y1)/2);
        }
        else{
          strokeWeight(2.2);fill(255);
          circle((x2+x1)/2,(y2+y1)/2,proportion*3.1);
          fill(0);textAlign(CENTER,CENTER);textSize(proportion*2.1);
          text(str(grado),(x2+x1)/2,(y2+y1)/2);
        }
        pop();
      }
     }
  }
  
  void reducirGrado(){
    grado--;
  }
  void aumentarGrado(){
    tipo=2;
    gradoOriginal++;
    grado=gradoOriginal;
  }
  void unitaria(Node node1,Node node2){
    x1=node1._x;
    y1=node1._y;
    x2=node2._x;
    y2=node2._y;
    tipo=0;
    grado=1;
    gradoOriginal=grado;
  }
  void cambiarColor(){
    stroke=colorArista2;
  }
  
  boolean verificarConexion(Node nodo1,Node nodo2){
    if(tipo==0){
      if(nodo1._x==x2 && nodo1._y==y2 && nodo2._x==x1 && nodo2._y==y1 && grado>0){
      return true;
      }
      else return false;
    }
    else{
      if((nodo1._x==x1 && nodo1._y==y1 && nodo2._x==x2 && nodo2._y==y2
      || nodo2._x==x1 && nodo2._y==y1 && nodo1._x==x2 && nodo1._y==y2) && grado>0){
      return true;
      }
      else return false;
    }
  }
  
  void reiniciar(){
    grado=gradoOriginal;
    stroke=colorArista;
  }
  int getTipo(){
    return tipo;
  }
  int getGrado(){
    return gradoOriginal;
  }
  void flecha(float pX,float pY,float angulo){
    pushMatrix();
    translate(pX,pY);
    rotate(angulo);
    stroke(255);
    strokeWeight(proportion);
    line(0,0,-proportion*2,-proportion*2);
    line(0,0,-proportion*2,proportion*2);
    stroke(0);
    strokeWeight(proportion*0.75);
    line(0,0,-proportion*1.9,-proportion*1.9);
    line(0,0,-proportion*1.9,proportion*1.9);
    popMatrix();
  }

}
