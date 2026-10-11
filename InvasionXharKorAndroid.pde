/**
 * INVASION DE LOS XHAR'KOR - VERSION ANDROID
 *
 * Controles:
 * - Pulgar izquierdo: joystick/esfera de vuelo.
 * - Pulgar derecho: RAFAGA, MISIL o LASER.
 * - Los dos pulgares funcionan simultaneamente mediante touches[].
 */

Game game;
int[] idsToque = new int[0];
float[] xsToque = new float[0];
float[] ysToque = new float[0];

void settings(){
  fullScreen(P2D);
}

void setup(){
  orientation(LANDSCAPE);
  frameRate(60);
  game = new Game(this);
  game.activarModoMovil();
}

void draw(){
  sincronizarToquesAndroid();
  game.update();
  game.display();
}

void sincronizarToquesAndroid(){
  int total = touches.length;
  if(idsToque.length != total){
    idsToque = new int[total];
    xsToque = new float[total];
    ysToque = new float[total];
  }

  for(int i = 0; i < total; i++){
    idsToque[i] = touches[i].id;
    xsToque[i] = touches[i].x;
    ysToque[i] = touches[i].y;
  }

  game.actualizarToques(idsToque, xsToque, ysToque);
}

void touchStarted(){
  if(game.estaEnRegistro()){
    openKeyboard();
  }else if(game.estaEnIntro()){
    game.iniciarNivel();
  }else if(game.estaJuegoPausado()){
    float toqueX = mouseX;
    float toqueY = mouseY;
    if(touches.length > 0){
      toqueX = touches[touches.length - 1].x;
      toqueY = touches[touches.length - 1].y;
    }
    game.intentarAccionPausa(toqueX, toqueY);
  }else if(game.estaFinalizado()){
    float toqueX = mouseX;
    float toqueY = mouseY;
    if(touches.length > 0){
      toqueX = touches[0].x;
      toqueY = touches[0].y;
    }
    game.intentarAccionFinal(toqueX, toqueY);
  }
}

void keyPressed(){
  boolean estabaRegistrando = game.estaEnRegistro();
  game.keyPressed(keyCode, key);
  if(estabaRegistrando && !game.estaEnRegistro()){
    closeKeyboard();
  }
}

void keyReleased(){
  game.keyReleased(keyCode);
}
