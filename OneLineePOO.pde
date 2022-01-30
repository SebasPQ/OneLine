ArrayList<Graph> _levels = new ArrayList<Graph>();
ArrayList<Graph> _created_levels=new ArrayList<Graph>();
PFont fuente;

float _dim = 9.5;
float proportion=((pow(2, _dim))/100);

int[] R={226,117,162,232,210,30 ,249,44 ,199,34,209,200,58 };
int[] G={62 ,46 ,247,17 ,83 ,66 ,123,186,170,75,57 ,157,169};
int[] B={39 ,53 ,60 ,136,21 ,170, 3 ,135,95 ,39,111,159,231};

int colorNum=round(random(12));
int num;
int _currentLevel=0;
int nodos_conectados;
int colorR=R[colorNum];
int colorG=G[colorNum];
int colorB=B[colorNum];

boolean dentro_boton;
boolean pantalla_inicio;
boolean pantalla_niveles;
boolean pantalla_crear;
boolean pantalla_niveles_creados;
boolean pantalla_guardar_nivel;
boolean pantalla_info;
boolean modo_nodo;
boolean modo_arista;
boolean modo_arista_uni;
boolean creando_grafo;
boolean guardado;
boolean nivel_default;
boolean nivel_creado;

color colorArista=color(colorR,colorG,colorB);
color colorNodo=color(colorR+15,colorG+15,colorB+15);
color colorArista2=color(colorR-45,colorG-45,colorB+45);
color colorNodo2=color(colorR-30,colorG-30,colorB+30);


Button next_level =new Button(85,94,"Sig Nivel",18,6);
Button prev_level =new Button(15,94,"Ant Nivel",18,6);
Button reset      =new Button(85,7,"Reintentar",18,6);
Button back       =new Button(15,7,"Volver",18,6);
Button play       =new Button(50,50,"Jugar",18,6);
Button create     =new Button(50,60,"Crear",18,6);
Button exit       =new Button(50,70,"Salir",18,6);
Button save       =new Button(85,7,"Guardar",18,6);
Button undo       =new Button(85,94,"Deshacer",18,6);
Button made_levels=new Button(50,94,"Niveles creados",27,6);
Button info       =new Button(10,94,"?",6,6);

Graph grafo_creado;
JSONArray levels_json=new JSONArray();
JSONArray created_levels_json=new JSONArray();
Graph graph;
Node nodo_creador;
Node nodo_n1,nodo_n2,nodo_u1,nodo_u2;
Arista arista_normal_creador;
Arista arista_uni_creador;

void settings() {
  size(int(pow(2, _dim)), int(pow(2, _dim)));
}

void setup() {
  
  levels_json=loadJSONArray("LevelsList.json");
  instanciarGrafos(_levels,levels_json);
  created_levels_json=loadJSONArray("CreatedLevels.json");
  instanciarGrafos(_created_levels,created_levels_json);
  
  pantalla_inicio=true;
  
  nodo_creador=new Node(25,94);
  nodo_n1=new Node(35,94);
  nodo_n2=new Node(45,94);
  nodo_u1=new Node(55,94);
  nodo_u2=new Node(65,94);
  arista_normal_creador=new Arista(nodo_n1,nodo_n2,1,1);
  arista_uni_creador=new Arista(nodo_u1,nodo_u2,0,1);
  
  fuente = loadFont("CenturyGothic-Bold-48.vlw");
  textFont(fuente);
  
}

void draw() {
  background(255-colorR,255-colorG,255-colorB);
  
  if(pantalla_inicio){//Pantalla de Inicio
    push();
    textAlign(CENTER,CENTER);
    textSize(proportion*14);
    fill(15,15,15,180); text("1LINE",50.4*proportion,32.4*proportion);
    fill(colorNodo2); text("1LINE",50*proportion,32*proportion);
    textSize(proportion*2.7);
    fill(15,15,15,180); text("By Sebastián Piñerez",50.1*proportion,40.1*proportion);
    text("v.1.0",50.1*proportion,90.1*proportion);
    fill(colorNodo2); text("By Sebastián Piñerez",50*proportion,40*proportion);
    text("v.1.0",50*proportion,90*proportion);

    pop();
    play.draw(true);
    create.draw(true);
    exit.draw(true);
    save.inactivo();
  }

  else if(pantalla_niveles){
    back.draw(true);
    made_levels.draw(true);
    push();
    textAlign(CENTER,CENTER);
    textSize(proportion*4.5);
    fill(15,15,15,180); text("Selecciona un nivel",52.2*proportion,8.2*proportion);
    fill(colorNodo2); text("Selecciona un nivel",52*proportion,8*proportion);
    
    for(int i=0;i<_levels.size();i++){
      _levels.get(i).boton().draw(true);
    }
    pop();
  }
  else if(pantalla_niveles_creados){
    back.draw(true);
    push();
    textAlign(CENTER,CENTER);
    textSize(proportion*4.5);
    fill(15,15,15,180); text("Mis niveles",50.2*proportion,8.2*proportion);
    fill(colorNodo2); text("Mis niveles",50*proportion,8*proportion);
    
    for(int i=0;i<_created_levels.size();i++){
      _created_levels.get(i).boton().draw(true);
    }
    pop();
  }
  //Juego
  else if(nivel_default){
    made_levels.inactivo();
    juego(_levels);
  }
  else if(nivel_creado){
    made_levels.inactivo();
    juego(_created_levels);
  }
  //pantalla creador
  else if(pantalla_crear){
    back.draw(true);
    undo.draw(false);
    info.draw(true);
    
    push();
    stroke(colorNodo2);
    strokeWeight(proportion*4);
    if(modo_nodo){
      circle(nodo_creador._x,nodo_creador._y,int(proportion*3));
    }
    else if(modo_arista){
      line(arista_normal_creador.x1,arista_normal_creador.y1,
           arista_normal_creador.x2,arista_normal_creador.y2);
    }
    else if(modo_arista_uni){
      line(arista_uni_creador.x1,arista_uni_creador.y1,
           arista_uni_creador.x2,arista_uni_creador.y2);
    }
    pop();
    
    nodo_creador.draw();
    arista_normal_creador.draw();
    arista_uni_creador.draw();
    
    push();
    textAlign(CENTER,CENTER);
    textSize(proportion*4.5);
    fill(15,15,15,180); text("¡Crea un nivel!",50.2*proportion,5.2*proportion);
    fill(colorNodo2); text("¡Crea un nivel!",50*proportion,5*proportion);
    textSize(proportion*2.5);
    text("nodos: "+str(grafo_creado._nodes.size()),44*proportion,9*proportion);
    text("aristas: "+str(grafo_creado._aristas.size()),56*proportion,9*proportion);
    strokeWeight(proportion);
    stroke(colorNodo2);
    fill(255);
    rectMode(CENTER);
    rect(50*proportion,50*proportion,84.5*proportion,76.5*proportion);
    
    //lineas verticales
    for(int i=8;i<93;i+=2){
      strokeWeight(proportion/4);
      if(i==50){
        stroke(90);
      }else stroke(140);
      
      line(i*proportion,12.3*proportion,i*proportion,87.69*proportion);
    }
    //lineas horizontales
    for(int i=12;i<90;i+=2){
      strokeWeight(proportion/4);
      if(i==50){
        stroke(90);
      }else stroke(140);
      line(8.3*proportion,i*proportion,91.7*proportion,i*proportion);
    }
    
    pop();
    if (grafo_creado._nodes.size()>0){
      grafo_creado.draw();
      undo.draw(true);
    }
    nodos_conectados=0;
    for(int i=0;i<grafo_creado._nodes.size();i++){
      if (grafo_creado._nodes.get(i).aristas_conectadas>0){
        nodos_conectados++;
      }
    }
    if(nodos_conectados==grafo_creado._nodes.size() && grafo_creado._nodes.size()>1){
        save.draw(true);
      }
     else{
        save.draw(false);
      }
  }
  else if(pantalla_guardar_nivel){
    grafo_creado.draw();
    reset.draw(true);
    back.draw(true);
    push();
    textAlign(CENTER,CENTER);
    textSize(proportion*4.5);
    fill(15,15,15,180); text("¡Supera el nivel!",51.2*proportion,8.2*proportion);
    fill(colorNodo2); text("¡Supera el nivel!",51*proportion,8*proportion);
    pop();
    if(grafo_creado.completado()){
      push();
      textSize(proportion*4.5);
      fill(15,15,15,180); text("¡Guardado!",36.2*proportion,95.2*proportion);
      fill(colorNodo2); text("¡Guardado!",36*proportion,95*proportion);
      pop();
      guardado=true;
    }
  }
  else if(pantalla_info){
    back.draw(true);
    push();
    textAlign(CENTER,CENTER);
    textSize(proportion*4.5);
    fill(15,15,15,180); text("Instrucciones",52.2*proportion,8.2*proportion);
    fill(colorNodo2); text("Instrucciones",52*proportion,8*proportion);
    textSize(proportion*3);
    fill(colorNodo2); 
    textAlign(LEFT,CENTER);
    text("- Selecciona el nodo de la parte inferior y luego haz\n   clic en la superficie para crear un nodo.",8*proportion,20*proportion);
    text("- Elige entre arista normal o arista direccional y crea\n  una conexión entre 2 nodos haciendo clic.",8*proportion,30*proportion);
    text("- La arista direccional siempre apunta al segundo nodo\n   cliqueado.",8*proportion,40*proportion);
    text("- Para aumentar el grado de una arista, debes crear\n   nuevamente una conexión entre los nodos que unen\n   a dicha arista.",8*proportion,52*proportion);
    text("- Todos los nodos deben tener al menos una conexión.",8*proportion,62*proportion);
    text("- Para guardar tu nivel, ¡debes ser capaz de superarlo!",8*proportion,68*proportion);
    
    pop();
  }
}

void mouseMoved(){
//-----------------mouse detecter---------------

  if(nivel_default){_levels.get(_currentLevel).mouseMoved();}
  if(nivel_creado){_created_levels.get(_currentLevel).mouseMoved();}
  
  //verifica si está encima de un botón y lo cambia de tamaño
  dentro_boton=false;
  next_level.cambiar(next_level.above());
  prev_level.cambiar(prev_level.above());
  reset.cambiar(reset.above());
  back.cambiar(back.above());
  play.cambiar(play.above());
  create.cambiar(create.above());
  exit.cambiar(exit.above());
  save.cambiar(save.above());
  undo.cambiar(undo.above());
  made_levels.cambiar(made_levels.above());
  info.cambiar(info.above());
  if(pantalla_guardar_nivel){
    grafo_creado.mouseMoved();
  }
  for(int i=0;i<_levels.size();i++){
    _levels.get(i).boton().cambiar(_levels.get(i).boton().above());
    }
  for(int i=0;i<_created_levels.size();i++){
    _created_levels.get(i).boton().cambiar(_created_levels.get(i).boton().above());
    }

}
void mouseClicked(){
  if(nivel_default){
   cambiarNivel(_levels);
  }
  if(nivel_creado){
   cambiarNivel(_created_levels);
  }
  if (pantalla_niveles){
    for(int i=0;i<_levels.size();i++){
        if(_levels.get(i).boton().above()){
          pantalla_niveles=false;
          pantalla_niveles_creados=false;
          _currentLevel=i;
          _levels.get(_currentLevel).reiniciarGrafo();
          nivel_creado=false;
          nivel_default=true;
        }
      }
    }
  if (pantalla_niveles_creados){
    
    for(int j=0;j<_created_levels.size();j++){
      
        if(_created_levels.get(j).boton().above()){
          pantalla_niveles_creados=false;
          pantalla_niveles=false;
          _currentLevel=j;
          _created_levels.get(_currentLevel).reiniciarGrafo();
          nivel_default=false;
          nivel_creado=true;
        }
      }
    }
  if(reset.above()){
    if(nivel_default){_levels.get(_currentLevel).reiniciarGrafo();}
    if(nivel_creado){_created_levels.get(_currentLevel).reiniciarGrafo();}
    if(pantalla_guardar_nivel){grafo_creado.reiniciarGrafo();}
    next_level.inactivo();
    prev_level.inactivo();
  }
  if(back.above()){
    if(pantalla_niveles){
      botonesInactivos();
      pantalla_inicio=true;
      pantalla_niveles=false;
      play.activo();
      create.activo();
      exit.activo();
    }
    else if(pantalla_crear){
      pantalla_inicio=true;
      pantalla_crear=false;
    }
    else if(pantalla_niveles_creados){
      pantalla_niveles=true;
      pantalla_niveles_creados=false;
    }
    else if(nivel_creado){
      nivel_creado=false;
      pantalla_niveles_creados=true;
    }
    else if(pantalla_guardar_nivel && guardado){
      
      grafo_creado.save(_created_levels.size()+1);
      created_levels_json.setJSONObject(_created_levels.size(),grafo_creado.graphJson());
      
      saveJSONArray(created_levels_json,"data/CreatedLevels.json");
      created_levels_json=loadJSONArray("CreatedLevels.json");
      
      _created_levels.add(new Graph(created_levels_json.getJSONObject(created_levels_json.size()-1)));
      
      grafo_creado=new Graph(_created_levels.size());
      pantalla_guardar_nivel=false;
      guardado=false;
      pantalla_crear=true;
    }
    else if(pantalla_guardar_nivel && guardado==false){
      grafo_creado.reiniciarGrafo();
      pantalla_guardar_nivel=false;
      pantalla_crear=true;
    }
    else if(pantalla_info==true){
      pantalla_info=false;
      pantalla_crear=true;
    }
    else{
      pantalla_niveles=true;
    }
    reset.inactivo();
    next_level.inactivo();
    prev_level.inactivo();
  }
  if(play.above()){
    pantalla_inicio=false;
    pantalla_niveles=true;
    exit.inactivo();
    create.inactivo();
    play.inactivo();
  }
  if(create.above()){
    guardado=false;
    nivel_default=false;
    nivel_creado=false;
    modo_nodo=false;
    modo_arista=false;
    create.inactivo();
    play.inactivo();
    exit.inactivo();
    made_levels.inactivo();
    pantalla_inicio=false;
    pantalla_crear=true;
    grafo_creado=new Graph(_created_levels.size());
    creando_grafo=true;
  }
  if(exit.above()){
    exit();
  }
  if(undo.above()){
    if(modo_nodo && grafo_creado._nodes.size()>0){
      for(int i=0;i<grafo_creado._aristas.size();i++){
        if(grafo_creado._aristas.get(i).x1==grafo_creado._nodes.get(grafo_creado._nodes.size()-1)._x
        && grafo_creado._aristas.get(i).y1==grafo_creado._nodes.get(grafo_creado._nodes.size()-1)._y
        || grafo_creado._aristas.get(i).x2==grafo_creado._nodes.get(grafo_creado._nodes.size()-1)._x
        && grafo_creado._aristas.get(i).y2==grafo_creado._nodes.get(grafo_creado._nodes.size()-1)._y){
          
           for(int j=0;j<grafo_creado._nodes.size();j++){
             if(grafo_creado._aristas.get(i).x1==grafo_creado._nodes.get(j)._x
                && grafo_creado._aristas.get(i).y1==grafo_creado._nodes.get(j)._y
                || grafo_creado._aristas.get(i).x2==grafo_creado._nodes.get(j)._x
                && grafo_creado._aristas.get(i).y2==grafo_creado._nodes.get(j)._y){
                   grafo_creado._nodes.get(j).reducir_aristas();
             }
           }
           grafo_creado._aristas.remove(i);
        }
      }
      grafo_creado._nodes.remove(grafo_creado._nodes.size()-1);
    }
    else if((modo_arista || modo_arista_uni) && grafo_creado._aristas.size()>0){
      for(int j=0;j<grafo_creado._nodes.size();j++){
         if(grafo_creado._aristas.get(grafo_creado._aristas.size()-1).x1==grafo_creado._nodes.get(j)._x
            && grafo_creado._aristas.get(grafo_creado._aristas.size()-1).y1==grafo_creado._nodes.get(j)._y
            || grafo_creado._aristas.get(grafo_creado._aristas.size()-1).x2==grafo_creado._nodes.get(j)._x
            && grafo_creado._aristas.get(grafo_creado._aristas.size()-1).y2==grafo_creado._nodes.get(j)._y){
            
              grafo_creado._nodes.get(j).reducir_aristas();
          }
      }
      grafo_creado._aristas.remove(grafo_creado._aristas.size()-1);
    }
    else if((modo_arista || modo_arista_uni) && grafo_creado._aristas.size()==0 && grafo_creado._nodes.size()>0){
      grafo_creado._nodes.remove(grafo_creado._nodes.size()-1);
    }
  }
  if(save.above()){
    pantalla_niveles=false;
    pantalla_niveles_creados=false;
    creando_grafo=false;
    grafo_creado.save(_created_levels.size());
    grafo_creado.reiniciarGrafo();
    botonesInactivos();
    back.activo();
    reset.activo();
    pantalla_guardar_nivel=true;
    pantalla_crear=false;
  }
  if(pantalla_crear){
    if (nodo_creador.inside()){
        grafo_creado.creando_arista=false;
        modo_nodo=true;
        modo_arista=false;
        modo_arista_uni=false;
    }
    if (insideEdge(arista_normal_creador)){
       grafo_creado.creando_arista=false;
       modo_arista=true;
       modo_arista_uni=false;
       modo_nodo=false;
    } 
    if (insideEdge(arista_uni_creador)){
       grafo_creado.creando_arista=false;
       modo_arista_uni=true;
       modo_arista=false;
       modo_nodo=false;
    }
  }
  if(info.above()){
    pantalla_info=true;
    pantalla_crear=false;
    botonesInactivos();
    back.activo();
  }
  if (pantalla_crear && creando_grafo && pantalla_info==false){
    creator();
  }
  if(made_levels.above()){
    made_levels.inactivo();
    pantalla_niveles=false;
    pantalla_niveles_creados=true;
  }  
}
void juego(ArrayList<Graph> lista){
    lista.get(_currentLevel).draw();
    reset.draw(true);
    back.draw(true);
    for(int i=0;i<_levels.size();i++){
      _levels.get(i).boton().inactivo();
    }
    for(int i=0;i<_created_levels.size();i++){
      _created_levels.get(i).boton().inactivo();
    }
    if(lista.get(_currentLevel).completado()){
      if(_currentLevel==lista.size()-1){
        next_level.draw(false);
      }
      else next_level.draw(true);
      
      if(_currentLevel==0 || lista.size()==1){
        prev_level.draw(false);
      }else prev_level.draw(true);
      
      push();
      textSize(proportion*4.5);
      fill(15,15,15,180); text(" ¡Completado!",34.1*proportion,95.1*proportion);
      fill(colorNodo2); text(" ¡Completado!",34*proportion,95*proportion);
      pop();
    }
}
void instanciarGrafos(ArrayList<Graph> _lista, JSONArray lista_json){

  for (int j = 0; j < lista_json.size(); j++) {
       _lista.add(new Graph(lista_json.getJSONObject(j)));

    }
}
void botonesInactivos(){
  next_level.inactivo();
  prev_level.inactivo();
  reset.inactivo();
  back.inactivo();
  play.inactivo();
  create.inactivo();
  exit.inactivo();
  save.inactivo();
  undo.inactivo();
  made_levels.inactivo();
  info.inactivo();
  if(pantalla_niveles==false){
    for(int i=0;i<_levels.size();i++){
    _levels.get(i).boton().inactivo();
    }
  }

  if(pantalla_niveles_creados==false){
    for(int i=0;i<_created_levels.size();i++){
    _created_levels.get(i).boton().inactivo();
    }
  }
}
void cambiarNivel(ArrayList<Graph> lista){
  if(next_level.above() && _currentLevel<lista.size()-1){
      _currentLevel++;
      lista.get(_currentLevel).reiniciarGrafo();
      next_level.inactivo();
      prev_level.inactivo();
    }
    if(prev_level.above() && _currentLevel>0){
    _currentLevel--;
    lista.get(_currentLevel).reiniciarGrafo();
    next_level.inactivo();
    prev_level.inactivo();
    }
}
boolean insideEdge(Arista arista){
  if(mouseX>arista.x1 && mouseY>arista.y1-proportion*2 
  && mouseX<arista.x2 && mouseY<arista.y2+proportion*2){
    return true;
  }
  else return false;
}
