class Enemy{
  PApplet p;
  float x, y;
  PImage img;
  SoundManager sound;
  int nivelActual;
  ArrayList<Bullet> enemyBullets;
  int contadorDisparo = 0;
  int cadenciaDisparo = 90;
  int maxBalasEnemigas = 75;
  
  int vidasMaximas;
  int vidasActuales;
  float velocidadY;
  float velocidadX;
  int danioAlJugador = 1;
  float escalaVisual = 1;
  boolean activoEnCombate = true;
  boolean invulnerable = false;
  int impactoBlindajeFrames = 0;
  
  Enemy(PApplet p, float x, float y, SoundManager sound, int nivelActual, ArrayList<Bullet> enemyBullets){
    this.p = p;
    this.x = x;
    this.y = y;
    this.sound = sound;
    this.nivelActual = nivelActual;
    this.enemyBullets = enemyBullets;
    this.escalaVisual = constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
    this.vidasMaximas = 3;
    this.vidasActuales = 3;
    this.velocidadY = 1;
    this.velocidadX = 0;
  }

  void update(){
    x += velocidadX;
    y += velocidadY;
    if(y < 60 * escalaVisual || y > p.height * 0.68f){
      velocidadY *= -1;
    }
  }
  
  void update(Player player, ArrayList<Bullet> enemyBullets){
    this.enemyBullets = enemyBullets;
    update();
    actualizarDisparo();
    if(player != null){
      float dx = (player.x - x) * 0.025;
      float dy = (player.y - y) * 0.015;
      x += dx + sin(frameCount * 0.04) * 2.0;
      y += dy + cos(frameCount * 0.03) * 1.2;
    }
    x = constrain(x, 40 * escalaVisual, p.width - 40 * escalaVisual);
    y = constrain(y, 50 * escalaVisual, p.height * 0.70f);
  }
  
  void disparar(){
    if(enemyBullets == null) return;
  }

  void actualizarDisparo(){
    contadorDisparo++;
    if(contadorDisparo >= cadenciaDisparo){
      disparar();
      contadorDisparo = 0;
    }
  }

  void actualizarEstadoDefensivo(){
    if(impactoBlindajeFrames > 0) impactoBlindajeFrames--;
  }

  void marcarImpactoBlindaje(){
    impactoBlindajeFrames = 8;
  }

  boolean esObjetivoValido(){
    return activoEnCombate && !invulnerable;
  }

  void recibirDanio(int tipoProyectil, int cantidadDanio){
    if(invulnerable){
      marcarImpactoBlindaje();
      return;
    }
    int ajuste = cantidadDanio;
    // El tipo de proyectil puede afectar daño en subclases
    if(tipoProyectil == Bullet.TIPO_METRALLETA){
      ajuste = cantidadDanio;
    }
    vidasActuales -= ajuste;
  }
  
  boolean estaDestruida(){
    return vidasActuales <= 0;
  }
  
  boolean colisiona(Player player){
    float dx = x - player.x;
    float dy = y - player.y;
    float radio = 60 * escalaVisual;
    return dx * dx + dy * dy < radio * radio;
  }

  void display(){
    p.pushStyle();
    p.imageMode(CENTER);
    if(img != null){
      if(!activoEnCombate) p.tint(125, 165);
      p.image(img, x, y);
      p.noTint();
    }
    
    // Mostrar barra de vida
    p.fill(255, 0, 0);
    p.rect(x - 30 * escalaVisual, y + 50 * escalaVisual, 60 * escalaVisual, 5 * escalaVisual);
    p.fill(0, 255, 0);
    float ancho = map(vidasActuales, 0, vidasMaximas, 0, 60 * escalaVisual);
    p.rect(x - 30 * escalaVisual, y + 50 * escalaVisual, ancho, 5 * escalaVisual);
    if(invulnerable){
      p.noFill();
      p.stroke(impactoBlindajeFrames > 0 ? p.color(255, 255, 255) : p.color(60, 205, 255, 210));
      p.strokeWeight(impactoBlindajeFrames > 0 ? 5 : 3);
      p.ellipse(x, y, 145 * escalaVisual, 145 * escalaVisual);
      p.fill(170, 230, 255);
      p.noStroke();
      p.textAlign(CENTER, CENTER);
      p.textSize(max(12, 14 * escalaVisual));
      p.text(activoEnCombate ? "BLINDAJE" : "EN ESPERA", x, y + 72 * escalaVisual);
    }
    p.popStyle();
  }
}

class EnemyNaveRoja extends Enemy {
  
  EnemyNaveRoja(PApplet p, float x, float y, SoundManager sound, int nivelActual, ArrayList<Bullet> enemyBullets){
    super(p, x, y, sound, nivelActual, enemyBullets);
    img = sound.imagen("ovnirojo.png", int(80 * escalaVisual), int(80 * escalaVisual));
    float factorDificultad = 1.0f + (nivelActual - 1) * 0.18f;
    vidasMaximas = 2 + min(2, nivelActual - 1);
    vidasActuales = vidasMaximas;
    velocidadY = (2.2f + (nivelActual - 1) * 0.35f) * escalaVisual;
    velocidadX = (0.8f + (nivelActual - 1) * 0.2f) * escalaVisual;
    danioAlJugador = 1 + (nivelActual >= 4 ? 1 : 0);
    velocidadY *= factorDificultad;
    cadenciaDisparo = max(45, 90 - (nivelActual - 1) * 8);
    contadorDisparo = int(p.random(cadenciaDisparo));
  }
  
  void update(){
    super.update();
    y += velocidadY * (1.05f + 0.08f * (nivelActual - 1));
    x += sin(y * 0.12f + frameCount * 0.03f) * (2.2f + nivelActual * 0.35f);
  }
  
  void update(Player player, ArrayList<Bullet> enemyBullets){
    this.enemyBullets = enemyBullets;
    update();
    actualizarDisparo();
    if(player != null){
      float dx = (player.x - x) * (0.025f + 0.005f * (nivelActual - 1));
      float dy = (player.y - y) * (0.015f + 0.003f * (nivelActual - 1));
      x += dx + sin(frameCount * 0.06f) * (1.6f + nivelActual * 0.25f);
      y += dy + cos(frameCount * 0.04f) * (1.0f + nivelActual * 0.12f);
    }
    x = constrain(x, 60 * escalaVisual, p.width - 60 * escalaVisual);
    y = constrain(y, 50 * escalaVisual, p.height * 0.68f);
  }

  void disparar(){
    if(enemyBullets == null) return;
    if(enemyBullets.size() >= maxBalasEnemigas) return;
    sound.disparoOvni();
    enemyBullets.add(new Bullet(p, x, y + 25, Bullet.TIPO_LASER, sound, true));
  }

  void recibirDanio(int tipoProyectil, int cantidadDanio){
    if(invulnerable){
      marcarImpactoBlindaje();
      return;
    }
    // Misil y laser hacen daño normal
    if(tipoProyectil == Bullet.TIPO_MISIL || tipoProyectil == Bullet.TIPO_LASER){
      vidasActuales -= cantidadDanio;
    }else if(tipoProyectil == Bullet.TIPO_METRALLETA){
      // Metralleta hace daño reducido
      vidasActuales -= 1;
    }
  }
}

class EnemyNodriza extends Enemy {
  
  EnemyNodriza(PApplet p, float x, float y, SoundManager sound, int nivelActual, ArrayList<Bullet> enemyBullets){
    super(p, x, y, sound, nivelActual, enemyBullets);
    img = sound.imagen("nodriza.png", int(120 * escalaVisual), int(120 * escalaVisual));
    vidasMaximas = 10 + (nivelActual - 5) * 2;
    vidasActuales = vidasMaximas;
    velocidadY = (2.2f + (nivelActual - 1) * 0.35f) * escalaVisual;
    velocidadX = (0.8f + (nivelActual - 1) * 0.2f) * escalaVisual;
    danioAlJugador = 2;
    velocidadY *= 1.0f + (nivelActual - 1) * 0.18f;
    cadenciaDisparo = max(45, 90 - (nivelActual - 1) * 8);
    contadorDisparo = int(p.random(cadenciaDisparo));
  }
  
  void update(){
    super.update();
    y += velocidadY * (1.05f + 0.08f * (nivelActual - 1));
    x += sin(y * 0.12f + frameCount * 0.03f) * (2.2f + nivelActual * 0.35f);
    sound.movimientoNodriza();
  }
  
  void update(Player player, ArrayList<Bullet> enemyBullets){
    this.enemyBullets = enemyBullets;
    update();
    actualizarDisparo();
    if(player != null){
      float dx = (player.x - x) * (0.025f + 0.005f * (nivelActual - 1));
      float dy = (player.y - y) * (0.015f + 0.003f * (nivelActual - 1));
      x += dx + sin(frameCount * 0.06f) * (1.6f + nivelActual * 0.25f);
      y += dy + cos(frameCount * 0.04f) * (1.0f + nivelActual * 0.12f);
    }
    x = constrain(x, 60 * escalaVisual, p.width - 60 * escalaVisual);
    y = constrain(y, 50 * escalaVisual, p.height * 0.68f);
  }
  
  void disparar(){
    if(enemyBullets == null) return;
    if(enemyBullets.size() >= maxBalasEnemigas) return;
    sound.disparoOvni();
    enemyBullets.add(new Bullet(p, x, y + 25, Bullet.TIPO_LASER, sound, true));
  }

  void recibirDanio(int tipoProyectil, int cantidadDanio){
    if(invulnerable){
      marcarImpactoBlindaje();
      return;
    }
    if(tipoProyectil == Bullet.TIPO_LASER){
      // Laser hace daño normal (1 impacto)
      vidasActuales -= cantidadDanio;
    }else if(tipoProyectil == Bullet.TIPO_MISIL){
      // Misil hace más daño (2 impactos = destruida)
      vidasActuales -= 2;
    }else if(tipoProyectil == Bullet.TIPO_METRALLETA){
      // Metralleta hace muy poco daño
      // No se resta vida (poco efecto)
    }
  }
}

class EnemyCruceroEmperador extends Enemy {
  int rafagaCantidad = 5;
  int anchoCrucero = 480;
  int altoCrucero = 480;
  PImage imgLaserCrucero;

  EnemyCruceroEmperador(PApplet p, float x, float y, SoundManager sound, int nivelActual, ArrayList<Bullet> enemyBullets){
    super(p, x, y, sound, nivelActual, enemyBullets);
    anchoCrucero = int(anchoCrucero * escalaVisual);
    altoCrucero = int(altoCrucero * escalaVisual);
    img = sound.imagen("crucero_emperador.png", anchoCrucero, altoCrucero);
    if(img == null) img = sound.imagen("crucero_Emperdor.png", anchoCrucero, altoCrucero);
    imgLaserCrucero = sound.imagen("laser_crucero.png", int(42 * escalaVisual), int(140 * escalaVisual));
    vidasMaximas = 45;
    vidasActuales = vidasMaximas;
    velocidadY = 0.55 * escalaVisual;
    velocidadX = 1.2 * escalaVisual;
    danioAlJugador = 3;
    cadenciaDisparo = 900;
    contadorDisparo = 720;
  }

  void update(){
    x += velocidadX + sin(frameCount * 0.018) * 0.8;
    y += velocidadY + cos(frameCount * 0.014) * 0.35;

    if(x < 250 * escalaVisual || x > p.width - 250 * escalaVisual){
      velocidadX *= -1;
    }
    if(y < 170 * escalaVisual || y > p.height * 0.42){
      velocidadY *= -1;
    }

    x = constrain(x, 250 * escalaVisual, p.width - 250 * escalaVisual);
    y = constrain(y, 170 * escalaVisual, p.height * 0.42);
    sound.movimientoCrucero();
  }

  void update(Player player, ArrayList<Bullet> enemyBullets){
    this.enemyBullets = enemyBullets;
    update();
    actualizarDisparo();
    if(player != null){
      x += (player.x - x) * 0.004;
    }
  }

  void updateEnEspera(Player player, ArrayList<Bullet> enemyBullets){
    this.enemyBullets = enemyBullets;
    update();
    if(player != null){
      x += (player.x - x) * 0.002f;
    }
  }

  void disparar(){
    if(enemyBullets == null) return;
    if(enemyBullets.size() >= maxBalasEnemigas) return;
    sound.laserCrucero();
    dispararCircular(rafagaCantidad);
  }

  void dispararAtaqueUno(Player objetivo){
    reservarEspacio(15);
    sound.laserCrucero();
    dispararCircular(8);
    dispararAbanico(objetivo, 7, 0.16f);
  }

  void activarAtaquesIntensificados(Player objetivo){
    activoEnCombate = true;
    invulnerable = true;
    cadenciaDisparo = 210;
    rafagaCantidad = 16;
    contadorDisparo = 0;
    reservarEspacio(25);
    sound.laserCrucero();
    dispararCircular(16);
    dispararAbanico(objetivo, 9, 0.11f);
  }

  void activarFaseFinal(){
    activoEnCombate = true;
    invulnerable = false;
    cadenciaDisparo = 105;
    rafagaCantidad = 20;
    contadorDisparo = min(contadorDisparo, cadenciaDisparo - 1);
  }

  void dispararCircular(int cantidad){
    if(enemyBullets == null) return;
    for(int i = 0; i < cantidad; i++){
      if(enemyBullets.size() >= maxBalasEnemigas) break;
      float anguloDisparo = TWO_PI * i / cantidad;
      float dirX = cos(anguloDisparo);
      float dirY = sin(anguloDisparo);
      float origenX = x + dirX * 95 * escalaVisual;
      float origenY = y + dirY * 95 * escalaVisual;
      enemyBullets.add(new Bullet(p, origenX, origenY, Bullet.TIPO_LASER_CRUCERO, sound, true, false, imgLaserCrucero, dirX, dirY));
    }
  }

  void dispararAbanico(Player objetivo, int cantidad, float separacionAngular){
    if(enemyBullets == null || objetivo == null) return;
    float anguloBase = atan2(objetivo.y - y, objetivo.x - x);
    float centro = (cantidad - 1) * 0.5f;
    for(int i = 0; i < cantidad; i++){
      if(enemyBullets.size() >= maxBalasEnemigas) break;
      float anguloDisparo = anguloBase + (i - centro) * separacionAngular;
      float dirX = cos(anguloDisparo);
      float dirY = sin(anguloDisparo);
      float origenX = x + dirX * 95 * escalaVisual;
      float origenY = y + dirY * 95 * escalaVisual;
      enemyBullets.add(new Bullet(p, origenX, origenY, Bullet.TIPO_LASER_CRUCERO, sound, true, false, imgLaserCrucero, dirX, dirY));
    }
  }

  void reservarEspacio(int cantidad){
    if(enemyBullets == null) return;
    int limite = max(0, maxBalasEnemigas - cantidad);
    while(enemyBullets.size() > limite){
      enemyBullets.remove(0);
    }
  }

  boolean colisiona(Player player){
    float dx = x - player.x;
    float dy = y - player.y;
    float radio = 220 * escalaVisual;
    return dx * dx + dy * dy < radio * radio;
  }
  void display(){
    p.pushStyle();
    p.imageMode(CENTER);
    if(img != null){
      p.image(img, x, y);
    }else{
      p.noStroke();
      p.fill(130, 40, 180);
      p.ellipse(x, y, anchoCrucero, altoCrucero * 0.55);
    }

    float barraW = 260;
    float barraY = y + 245;
    p.noStroke();
    p.fill(90, 0, 0);
    p.rect(x - barraW / 2, barraY, barraW, 12);
    p.fill(255, 60, 40);
    float ancho = map(vidasActuales, 0, vidasMaximas, 0, barraW);
    p.rect(x - barraW / 2, barraY, ancho, 12);
    if(invulnerable){
      p.noFill();
      p.stroke(impactoBlindajeFrames > 0 ? p.color(255) : p.color(30, 190, 255, 220));
      p.strokeWeight(impactoBlindajeFrames > 0 ? 9 : 5);
      p.ellipse(x, y, anchoCrucero * 0.96f, altoCrucero * 0.62f);
      p.noStroke();
      p.fill(170, 230, 255);
      p.textAlign(CENTER, CENTER);
      p.textSize(max(16, 20 * escalaVisual));
      p.text("BLINDAJE ACTIVO", x, barraY + 38 * escalaVisual);
    }
    p.popStyle();
  }
}
