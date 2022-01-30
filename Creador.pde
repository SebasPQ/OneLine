void creator(){
  int grado;
  int tipo;
  boolean multi=false;
  if  (mouseX>proportion*10.3 && mouseY>proportion*14.3
    && mouseX<proportion*89.7 && mouseY<proportion*84.7){

    if(modo_nodo){
      grafo_creado.nuevoNodo(mouseX,mouseY);
    }
    
  }
  if(modo_arista || modo_arista_uni){
      if(modo_arista_uni){tipo=0;grado=1;}
      else{tipo=1;grado=1;}
      
      for(int i=0;i<grafo_creado._nodes.size();i++){
        if(grafo_creado._nodes.get(i).inside()){
           if(grafo_creado.estado_creacion()==false){

               grafo_creado.set_nodo_inicio(grafo_creado._nodes.get(i)._x,grafo_creado._nodes.get(i)._y);
               grafo_creado._nodes.get(i).aumentar_aristas();
           }
           else if(grafo_creado._nodes.get(i)._x!=grafo_creado.nodo_inicio._x ||
                   grafo_creado._nodes.get(i)._y!=grafo_creado.nodo_inicio._y ){
                     
               grafo_creado.set_nodo_fin(grafo_creado._nodes.get(i)._x,grafo_creado._nodes.get(i)._y);
               
               for(int j=0;j<grafo_creado._aristas.size();j++){
                 if (grafo_creado._aristas.get(j).x1==grafo_creado.nodo_inicio._x &&
                     grafo_creado._aristas.get(j).y1==grafo_creado.nodo_inicio._y &&
                     grafo_creado._aristas.get(j).x2==grafo_creado.nodo_fin._x &&
                     grafo_creado._aristas.get(j).y2==grafo_creado.nodo_fin._y ||
                     grafo_creado._aristas.get(j).x1==grafo_creado.nodo_fin._x &&
                     grafo_creado._aristas.get(j).y1==grafo_creado.nodo_fin._y &&
                     grafo_creado._aristas.get(j).x2==grafo_creado.nodo_inicio._x &&
                     grafo_creado._aristas.get(j).y2==grafo_creado.nodo_inicio._y){
                     
                     if(modo_arista_uni){
                       grafo_creado._aristas.get(j).unitaria(grafo_creado.nodo_inicio,grafo_creado.nodo_fin);
                     }
                     else{
                       grafo_creado._aristas.get(j).aumentarGrado();
                     }
                     multi=true;
                 }
               }
               if(multi==false){
                 grafo_creado.nuevaArista(grafo_creado.nodo_inicio,grafo_creado.nodo_fin,tipo,grado);
                 grafo_creado._nodes.get(i).aumentar_aristas();
             }
           }
        }
      }
   }
}
