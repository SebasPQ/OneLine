class Graph {
  ArrayList<Node> _nodes;
  ArrayList<Arista> _aristas;
  int nodes;
  int NodeX;
  int NodeY;
  int indice;
  int counter;
  int counter2;
  int nodoPrevio;
  int numAristas;
  int[][] coords;
  int[][] conections;
  Button botonNivel;
  
  //para modo creador
  Node nodo_inicio;
  Node nodo_fin;
  boolean creando_arista;
  JSONObject graphJson;
  JSONObject coordsJson;
  JSONObject conectionsJson;
  JSONArray values;
  
//*******************CONSTRUCTOR************************
  Graph(JSONObject graph){
    
    load(graph);
    
    botonNivel=new Button(indice,8,8);
  }
  
  Graph(int ind){
    _nodes = new ArrayList<Node>();
    _aristas = new ArrayList<Arista>();
    indice=ind+1;
    botonNivel=new Button(indice,8,8);
  }

  void load(JSONObject graph) {
    
    indice=graph.getInt("graph");
    nodes=graph.getInt("nodes");
    coords=new int[nodes][2];
    conections=new int[nodes][nodes];
    
    coordsJson = graph.getJSONObject("coords");
    for(int i=0;i<coordsJson.size();i++){
      coords[i]=coordsJson.getJSONArray(str(i+1)).getIntArray();
    }
    conectionsJson = graph.getJSONObject("conections");
    for(int i=0;i<conectionsJson.size();i++){
      conections[i]=conectionsJson.getJSONArray(str(i+1)).getIntArray();
    }
    
    _nodes = new ArrayList<Node>();
    for(int i=0; i<coords.length; i++){
      NodeX= coords[i][0];
      NodeY= coords[i][1];
      _nodes.add(new Node(NodeX,NodeY));
    } 
    
    _aristas = new ArrayList<Arista>();
    for (int i=0; i <conections.length;i++){
      for(int j=counter; j <conections.length;j++){
        //arista tipo 1 (normal)
        if (conections[i][j]==1 && conections[i][j]==conections[j][i]){
          _aristas.add(new Arista(_nodes.get(i),_nodes.get(j),1,conections[i][j]));
        }
        //arista tipo 2 (multidireccional)
        else if (conections[i][j]>1 && conections[i][j]==conections[j][i]){
          _aristas.add(new Arista(_nodes.get(i),_nodes.get(j),2,conections[i][j]));
        }
        //arista tipo 0 unidireccional
        else if (conections[i][j]==1 && conections[j][i]==0){
          _aristas.add(new Arista(_nodes.get(i),_nodes.get(j),0,1));
        }
        else if (conections[j][i]==1 && conections[i][j]==0){
          _aristas.add(new Arista(_nodes.get(j),_nodes.get(i),0,1));
        }
      }
      counter++;
    }
    contarAristas();
  }

  void save(int _indice) {
    graphJson=new JSONObject();
    nodes=_nodes.size();
    coords=new int[nodes][2];
    conections=new int[nodes][nodes];
    
    for(int i=0;i<_nodes.size();i++){
      coords[i][0]=round(_nodes.get(i).getX()/proportion);
      coords[i][1]=round(_nodes.get(i).getY()/proportion);
    }
    for(int i=0;i<_nodes.size();i++){
      for(int j=0;j<_nodes.size();j++){
        for(int k=0;k<_aristas.size();k++){
          
          if(_nodes.get(i)._x==_aristas.get(k).x1 && _nodes.get(i)._y==_aristas.get(k).y1
          && _nodes.get(j)._x==_aristas.get(k).x2 && _nodes.get(j)._y==_aristas.get(k).y2){
            if(_aristas.get(k).getTipo()==0){
              conections[i][j]=1;
            }
            else if(_aristas.get(k).getTipo()==1){
              conections[i][j]=1;
              conections[j][i]=1;
            }
            else{
              conections[i][j]=_aristas.get(k).getGrado();
              conections[j][i]=_aristas.get(k).getGrado();
            }
          }
        }
      }
    }
    contarAristas();
    
    coordsJson = new JSONObject();
    for(int i=0;i<nodes;i++){
      values=new JSONArray();
      for(int j=0;j<2;j++){
        values.setInt(j,coords[i][j]);
      }
      coordsJson.setJSONArray(str(i+1),values);
    }
    
    conectionsJson = new JSONObject();
    for(int i=0;i<nodes;i++){
      values=new JSONArray();
      for(int j=0;j<nodes;j++){
        values.setInt(j,conections[i][j]);
      }
      conectionsJson.setJSONArray(str(i+1),values);
    }
    graphJson.setInt("graph",_indice);
    graphJson.setInt("nodes",nodes);
    graphJson.setJSONObject("coords",coordsJson);
    graphJson.setJSONObject("conections",conectionsJson);

  }

  void draw() {
    for(Arista arista: _aristas)
      arista.draw();
    strokeWeight(proportion*2.8);
    if (counter2<=numAristas && counter2!=0 && dentro_boton==false){
      stroke(colorArista2,65);
      line(_nodes.get(nodoPrevio)._x,_nodes.get(nodoPrevio)._y,mouseX,mouseY);  
    }
    if (creando_arista && modo_nodo==false){
      stroke(colorArista2,65);
      line(grafo_creado.nodo_inicio._x,grafo_creado.nodo_inicio._y,mouseX,mouseY);
    }

    for(Node node : _nodes)
      node.draw();
  }
  
  void mouseMoved(){
//-----------------mouse detecter---------------
    for(int i=0;i<_nodes.size();i++){
      if(_nodes.get(i).inside()){
        if(counter2==0){
          _nodes.get(i).cambiarColor(colorNodo2);
          nodoPrevio=i;
          counter2++;
        }
        else{
          for(int j=0;j<_aristas.size();j++){
            if(_aristas.get(j).verificarConexion(_nodes.get(i),_nodes.get(nodoPrevio))){
              _nodes.get(i).cambiarColor(colorNodo2);
              _aristas.get(j).cambiarColor();
              _aristas.get(j).reducirGrado();
              nodoPrevio=i;
              counter2++;
              break;
            }
          }
        }
      }
    }
  }

  boolean completado(){
    if(counter2-1==numAristas){
    return true;
    }
    else return false;
  } 
  
  void reiniciarGrafo(){
    counter2=0;
    for(int i=0;i<_nodes.size();i++){
      _nodes.get(i).reiniciar();
    }
    for(int i=0;i<_aristas.size();i++){
      _aristas.get(i).reiniciar();
    }
  }
  Button boton(){
    return botonNivel;
  }
  void contarAristas(){
    numAristas=0;
    for(int i=0;i<_aristas.size();i++){
      if (_aristas.get(i).gradoOriginal==0){
        numAristas++;
      }
      else{
        numAristas+=_aristas.get(i).gradoOriginal;
      }
     }
  }
  
  void nuevoNodo(float x,float y){
    _nodes.add(new Node(x,y));
  }
  void nuevaArista(Node nodo1,Node nodo2,int tipo, int grado){
    _aristas.add(new Arista(nodo1,nodo2,tipo,grado));
  }
  void set_nodo_inicio(float x,float y){
    nodo_inicio=new Node(x,y);
    creando_arista=true;
  }
  void set_nodo_fin(float x,float y){
    nodo_fin=new Node(x,y);
    creando_arista=false;
  }
  boolean estado_creacion(){
    return creando_arista;
  }
  JSONObject graphJson(){
    return graphJson;
  }
}
