/**
 * Mando tactil multitoque para pantalla horizontal.
 *
 * Cada dedo conserva su ID. El joystick captura un dedo en la mitad
 * izquierda, el arma captura otro dedo y pausa usa una pulsacion propia.
 * De este modo movimiento, disparo y pausa nunca se bloquean entre si.
 */
class TouchControls{
  PApplet p;

  int joystickTouchId = -1;
  float joystickX;
  float joystickY;
  float joystickRadius;
  float knobRadius;
  float inputX = 0;
  float inputY = 0;

  float fireX;
  float fireY;
  float fireRadius;
  float missileX;
  float missileY;
  float laserX;
  float laserY;
  float secondaryRadius;
  float pauseX;
  float pauseY;
  float pauseRadius;

  boolean rafagaActiva = false;
  boolean misilActivo = false;
  boolean laserActivo = false;
  boolean pausaActiva = false;
  boolean juegoPausado = false;
  int weaponTouchId = -1;
  int pauseTouchId = -1;
  int armaActiva = 0; // 0=ninguna, 1=rafaga, 2=misil, 3=laser
  boolean visible = false;
  int layoutWidth = -1;
  int layoutHeight = -1;
  PFont fuenteBotones;
  float tamanoFuenteBotones;

  TouchControls(PApplet p){
    this.p = p;
    recalcularLayout();
  }

  void recalcularLayout(){
    if(layoutWidth == p.width && layoutHeight == p.height) return;
    layoutWidth = p.width;
    layoutHeight = p.height;

    float ladoCorto = min(p.width, p.height);
    float margen = max(18, ladoCorto * 0.035f);

    joystickRadius = constrain(ladoCorto * 0.122f, 68, 154);
    knobRadius = joystickRadius * 0.43f;
    joystickX = margen + joystickRadius;
    joystickY = p.height - margen - joystickRadius;

    fireRadius = constrain(ladoCorto * 0.086f, 54, 116);
    secondaryRadius = fireRadius * 0.74f;
    fireX = p.width - margen - fireRadius;
    fireY = p.height - margen - fireRadius;

    float separacion = fireRadius * 1.88f;
    missileX = fireX - separacion * 1.05f;
    missileY = fireY - separacion * 0.08f;
    laserX = fireX - separacion * 0.56f;
    laserY = fireY - separacion * 1.02f;
    pauseRadius = constrain(ladoCorto * 0.052f, 32, 58);
    pauseX = p.width * 0.50f;
    pauseY = margen + pauseRadius;
    tamanoFuenteBotones = max(12, fireRadius * 0.25f);
    fuenteBotones = null;
  }

  void actualizar(int[] ids, float[] xs, float[] ys){
    if(!visible){
      liberar();
      return;
    }

    recalcularLayout();
    rafagaActiva = false;
    misilActivo = false;
    laserActivo = false;
    pausaActiva = false;

    int indiceJoystick = buscarToque(ids, joystickTouchId);
    if(indiceJoystick < 0){
      joystickTouchId = capturarJoystick(ids, xs, ys);
      indiceJoystick = buscarToque(ids, joystickTouchId);
    }

    if(indiceJoystick >= 0){
      actualizarJoystick(xs[indiceJoystick], ys[indiceJoystick]);
    }else{
      inputX = 0;
      inputY = 0;
    }

    int indiceArma = buscarToque(ids, weaponTouchId);
    if(indiceArma < 0){
      weaponTouchId = capturarArma(ids, xs, ys);
      indiceArma = buscarToque(ids, weaponTouchId);
    }

    if(indiceArma >= 0){
      actualizarArma(xs[indiceArma], ys[indiceArma]);
    }else{
      armaActiva = 0;
    }

    rafagaActiva = armaActiva == 1;
    misilActivo = armaActiva == 2;
    laserActivo = armaActiva == 3;

    int indicePausa = buscarToque(ids, pauseTouchId);
    if(indicePausa < 0){
      pauseTouchId = capturarPausa(ids, xs, ys);
      indicePausa = buscarToque(ids, pauseTouchId);
    }
    // Una vez capturado, el boton permanece activo hasta levantar el dedo.
    pausaActiva = indicePausa >= 0;
  }

  int capturarJoystick(int[] ids, float[] xs, float[] ys){
    for(int i = 0; i < ids.length; i++){
      boolean ladoIzquierdo = xs[i] < p.width * 0.48f;
      boolean zonaInferior = ys[i] > p.height * 0.48f;
      if(ladoIzquierdo && zonaInferior){
        return ids[i];
      }
    }
    return -1;
  }

  int buscarToque(int[] ids, int id){
    if(id < 0) return -1;
    for(int i = 0; i < ids.length; i++){
      if(ids[i] == id) return i;
    }
    return -1;
  }

  int capturarArma(int[] ids, float[] xs, float[] ys){
    for(int i = 0; i < ids.length; i++){
      if(ids[i] == joystickTouchId) continue;
      if(armaMasCercana(xs[i], ys[i], 1.60f) != 0){
        return ids[i];
      }
    }
    return -1;
  }

  int capturarPausa(int[] ids, float[] xs, float[] ys){
    for(int i = 0; i < ids.length; i++){
      if(dentro(xs[i], ys[i], pauseX, pauseY, pauseRadius * 1.30f)){
        return ids[i];
      }
    }
    return -1;
  }

  void actualizarArma(float touchX, float touchY){
    int nuevaArma = armaMasCercana(touchX, touchY, 1.60f);
    if(nuevaArma != 0){
      armaActiva = nuevaArma;
    }else if(touchX < p.width * 0.50f || touchY < p.height * 0.18f){
      // El pulgar puede desviarse un poco sin soltar el gatillo.
      armaActiva = 0;
    }
  }

  int armaMasCercana(float x, float y, float expansion){
    float distanciaRafaga = distanciaNormalizada(x, y, fireX, fireY, fireRadius);
    float distanciaMisil = distanciaNormalizada(x, y, missileX, missileY, secondaryRadius);
    float distanciaLaser = distanciaNormalizada(x, y, laserX, laserY, secondaryRadius);
    float limite = expansion * expansion;

    int arma = 1;
    float mejorDistancia = distanciaRafaga;
    if(distanciaMisil < mejorDistancia){
      arma = 2;
      mejorDistancia = distanciaMisil;
    }
    if(distanciaLaser < mejorDistancia){
      arma = 3;
      mejorDistancia = distanciaLaser;
    }
    return mejorDistancia <= limite ? arma : 0;
  }

  float distanciaNormalizada(float x, float y, float centroX, float centroY, float radio){
    float dx = (x - centroX) / radio;
    float dy = (y - centroY) / radio;
    return dx * dx + dy * dy;
  }

  void actualizarJoystick(float touchX, float touchY){
    float dx = touchX - joystickX;
    float dy = touchY - joystickY;
    float distancia = sqrt(dx * dx + dy * dy);
    float limite = joystickRadius * 0.78f;

    if(distancia > limite && distancia > 0.001f){
      dx = dx / distancia * limite;
      dy = dy / distancia * limite;
    }

    inputX = constrain(dx / limite, -1, 1);
    inputY = constrain(dy / limite, -1, 1);

    float magnitud = sqrt(inputX * inputX + inputY * inputY);
    float zonaMuerta = 0.12f;
    if(magnitud < zonaMuerta){
      inputX = 0;
      inputY = 0;
    }else{
      float ajustada = map(magnitud, zonaMuerta, 1, 0, 1);
      inputX = inputX / magnitud * ajustada;
      inputY = inputY / magnitud * ajustada;
    }
  }

  boolean dentro(float x, float y, float centroX, float centroY, float radio){
    float dx = x - centroX;
    float dy = y - centroY;
    return dx * dx + dy * dy <= radio * radio;
  }

  void liberar(){
    joystickTouchId = -1;
    weaponTouchId = -1;
    pauseTouchId = -1;
    armaActiva = 0;
    inputX = 0;
    inputY = 0;
    rafagaActiva = false;
    misilActivo = false;
    laserActivo = false;
    pausaActiva = false;
  }

  void display(){
    if(!visible) return;
    if(fuenteBotones == null){
      fuenteBotones = p.createFont("SansSerif Bold", tamanoFuenteBotones, true);
    }
    p.pushStyle();
    p.ellipseMode(CENTER);
    p.textAlign(CENTER, CENTER);

    // Base del mando de avion.
    p.noStroke();
    p.fill(3, 15, 30, 135);
    p.ellipse(joystickX, joystickY, joystickRadius * 2.25f, joystickRadius * 2.25f);
    p.stroke(70, 210, 255, 205);
    p.strokeWeight(max(2, joystickRadius * 0.025f));
    p.fill(12, 42, 70, 155);
    p.ellipse(joystickX, joystickY, joystickRadius * 2, joystickRadius * 2);
    p.noFill();
    p.stroke(125, 230, 255, 90);
    p.ellipse(joystickX, joystickY, joystickRadius * 1.25f, joystickRadius * 1.25f);

    float knobX = joystickX + inputX * joystickRadius * 0.78f;
    float knobY = joystickY + inputY * joystickRadius * 0.78f;
    p.noStroke();
    p.fill(0, 210, 255, 75);
    p.ellipse(knobX, knobY, knobRadius * 2.45f, knobRadius * 2.45f);
    p.fill(38, 145, 195, 230);
    p.ellipse(knobX, knobY, knobRadius * 2, knobRadius * 2);
    p.fill(135, 235, 255, 210);
    p.ellipse(knobX - knobRadius * 0.22f, knobY - knobRadius * 0.24f, knobRadius * 0.68f, knobRadius * 0.68f);

    dibujarBoton(fireX, fireY, fireRadius, "RAFAGA", rafagaActiva, p.color(255, 175, 20));
    dibujarBoton(missileX, missileY, secondaryRadius, "MISIL", misilActivo, p.color(255, 80, 45));
    dibujarBoton(laserX, laserY, secondaryRadius, "LASER", laserActivo, p.color(40, 170, 255));
    dibujarBotonPausa();

    p.fill(190, 230, 245, 185);
    p.textSize(constrain(min(p.width, p.height) * 0.024f, 14, 28));
    p.text("VUELO", joystickX, joystickY - joystickRadius - 18);
    p.popStyle();
  }

  void dibujarBoton(float x, float y, float radio, String etiqueta, boolean activo, int colorBase){
    p.noStroke();
    p.fill(3, 15, 30, 145);
    p.ellipse(x, y, radio * 2.25f, radio * 2.25f);
    p.stroke(colorBase);
    p.strokeWeight(max(2, radio * 0.04f));
    p.fill(activo ? colorBase : p.color(15, 40, 62, 190));
    p.ellipse(x, y, radio * 2, radio * 2);
    if(activo){
      p.noStroke();
      p.fill(255, 255, 255, 70);
      p.ellipse(x, y, radio * 1.46f, radio * 1.46f);
    }
    p.fill(255);
    p.textFont(fuenteBotones);
    p.textSize(max(12, radio * 0.25f));
    p.text(etiqueta, x, y);
  }

  void dibujarBotonPausa(){
    p.noStroke();
    p.fill(3, 15, 30, 185);
    p.ellipse(pauseX, pauseY, pauseRadius * 2.25f, pauseRadius * 2.25f);
    p.stroke(70, 210, 255, 225);
    p.strokeWeight(max(2, pauseRadius * 0.055f));
    p.fill(juegoPausado ? p.color(20, 120, 155, 235) : p.color(15, 40, 62, 220));
    p.ellipse(pauseX, pauseY, pauseRadius * 2, pauseRadius * 2);

    p.noStroke();
    p.fill(255);
    if(juegoPausado){
      p.triangle(
        pauseX - pauseRadius * 0.22f, pauseY - pauseRadius * 0.38f,
        pauseX - pauseRadius * 0.22f, pauseY + pauseRadius * 0.38f,
        pauseX + pauseRadius * 0.42f, pauseY
      );
    }else{
      float barraW = pauseRadius * 0.20f;
      float barraH = pauseRadius * 0.72f;
      p.rect(pauseX - pauseRadius * 0.34f, pauseY - barraH * 0.5f, barraW, barraH, 2);
      p.rect(pauseX + pauseRadius * 0.14f, pauseY - barraH * 0.5f, barraW, barraH, 2);
    }
  }
}
