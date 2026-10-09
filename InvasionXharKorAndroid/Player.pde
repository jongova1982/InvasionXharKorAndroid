class Player{
  PApplet p;
  float x, y;
  float xInicial, yInicial;
  PImage imgCentro, imgDerecha, imgIzquierda;
  SoundManager sound;
  
  int vidas = 10;
  int invulnerableFrames = 0;
  boolean left = false, right = false, up = false, down = false;
  int direccion = 0; // 0=centro, 1=derecha, -1=izquierda
  int frameMovimiento = 0;
  int contadorSonido = 0;
  float analogX = 0;
  float analogY = 0;
  float escalaVisual = 1;
  float velocidadMovimiento = 15;

  Player(PApplet p, SoundManager sound){
    this.p = p;
    this.sound = sound;
    
    // ESCALAR IMÁGENES A TAMAÑO CONSISTENTE
    escalaVisual = constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
    int tamano = int(100 * escalaVisual);
    imgCentro = sound.imagen("cazaf2_centro.png", tamano, tamano);
    imgDerecha = sound.imagen("cazaf2_der.png", tamano, tamano);
    imgIzquierda = sound.imagen("cazaf2_izq.png", tamano, tamano);
    // Velocidad tactica solicitada: 3 veces la velocidad original.
    velocidadMovimiento = 3.0f * constrain(min(p.width, p.height) * 0.0215f, 8, 25);
    
    xInicial = p.width / 2;
    yInicial = p.height * 0.70f;
    x = xInicial;
    y = yInicial;
  }
  
  void resetPos(){
    x = xInicial;
    y = yInicial;
    direccion = 0;
    frameMovimiento = 0;
  }

  void update(){
    if(invulnerableFrames > 0){
      invulnerableFrames--;
    }

    float tecladoX = (right ? 1 : 0) - (left ? 1 : 0);
    float tecladoY = (down ? 1 : 0) - (up ? 1 : 0);
    float movimientoX = constrain(tecladoX + analogX, -1, 1);
    float movimientoY = constrain(tecladoY + analogY, -1, 1);
    float magnitud = sqrt(movimientoX * movimientoX + movimientoY * movimientoY);
    if(magnitud > 1){
      movimientoX /= magnitud;
      movimientoY /= magnitud;
    }

    x += movimientoX * velocidadMovimiento;
    y += movimientoY * velocidadMovimiento;
    if(movimientoX < -0.08f){
      direccion = -1;
    }else if(movimientoX > 0.08f){
      direccion = 1;
    }else{
      direccion = 0;
    }
    
    // Reproducir sonido de movimiento cada 10 frames
    if(abs(movimientoX) > 0.08f || abs(movimientoY) > 0.08f){
      contadorSonido++;
      if(contadorSonido >= 10){
        sound.movimientoCaza();
        contadorSonido = 0;
      }
    }else{
      contadorSonido = 0;
    }
    
    // Limitar posición horizontal y vertical
    float margen = 50 * escalaVisual;
    x = constrain(x, margen, p.width - margen);
    y = constrain(y, max(90 * escalaVisual, p.height * 0.14f), p.height * 0.76f);
  }

  void setAnalogInput(float x, float y){
    analogX = constrain(x, -1, 1);
    analogY = constrain(y, -1, 1);
  }

  void display(){
    p.imageMode(CENTER);
    
    PImage imgActual = imgCentro;
    if(direccion == 1 && imgDerecha != null){
      imgActual = imgDerecha;
    }else if(direccion == -1 && imgIzquierda != null){
      imgActual = imgIzquierda;
    }
    
    if(imgActual != null){
      p.image(imgActual, x, y);
    }
  }
  
  void recibirDanio(){
    vidas--;
  }
  
  boolean estaDestruido(){
    return vidas <= 0;
  }

  boolean danio(){
    if(invulnerableFrames > 0){
      return false;
    }
    vidas--;
    invulnerableFrames = 45;
    return true;
  }

  void keyPressed(int keyCode){
    if(keyCode == LEFT) left = true;
    if(keyCode == RIGHT) right = true;
    if(keyCode == UP) up = true;
    if(keyCode == DOWN) down = true;
  }

  void keyReleased(int keyCode){
    if(keyCode == LEFT) left = false;
    if(keyCode == RIGHT) right = false;
    if(keyCode == UP) up = false;
    if(keyCode == DOWN) down = false;
  }
}

class SupportFighter{
  PApplet p;
  SoundManager sound;
  Player comandante;
  PImage imgCentro;
  PImage imgDerecha;
  PImage imgIzquierda;
  float x, y;
  float vx = 0;
  float vy = 0;
  int lado;
  int vidas = 10;
  int disparoCooldown = 0;
  int invulnerableFrames = 0;
  boolean activo = true;
  float escalaVisual = 1;

  SupportFighter(PApplet p, SoundManager sound, Player comandante, int lado){
    this.p = p;
    this.sound = sound;
    this.comandante = comandante;
    this.lado = lado;
    escalaVisual = constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
    int tamano = int(100 * escalaVisual);
    imgCentro = sound.imagen("cazaf2_centro.png", tamano, tamano);
    imgDerecha = sound.imagen("cazaf2_der.png", tamano, tamano);
    imgIzquierda = sound.imagen("cazaf2_izq.png", tamano, tamano);
    reset();
  }

  void reset(){
    vidas = 10;
    activo = true;
    x = constrain(comandante.x + lado * 130 * escalaVisual, 60 * escalaVisual, p.width - 60 * escalaVisual);
    y = constrain(comandante.y + 40 * escalaVisual, 120 * escalaVisual, p.height * 0.74f);
    vx = 0;
    vy = 0;
    disparoCooldown = 20 + int(p.random(30));
    invulnerableFrames = 0;
  }

  void update(ArrayList<Enemy> enemies, ArrayList<Bullet> bullets){
    if(!activo) return;
    if(invulnerableFrames > 0) invulnerableFrames--;

    Enemy objetivo = buscarObjetivo(enemies);
    float destinoX = comandante.x + lado * 115 * escalaVisual;
    float destinoY = comandante.y + 34 * escalaVisual;

    if(objetivo != null){
      destinoX = objetivo.x + lado * 44 * escalaVisual;
      destinoY = constrain(objetivo.y + 170 * escalaVisual, 130 * escalaVisual, p.height * 0.69f);
    }

    vx += (destinoX - x) * 0.012;
    vy += (destinoY - y) * 0.012;
    vx *= 0.88;
    vy *= 0.88;
    x += constrain(vx, -8, 8);
    y += constrain(vy, -7, 7);
    x = constrain(x, 45 * escalaVisual, p.width - 45 * escalaVisual);
    y = constrain(y, 105 * escalaVisual, p.height * 0.75f);

    if(disparoCooldown > 0) disparoCooldown--;
    if(objetivo != null && disparoCooldown <= 0 && bullets.size() < 60){
      bullets.add(new Bullet(p, x, y - 28, Bullet.TIPO_LASER, sound, false, false));
      disparoCooldown = 38 + int(p.random(24));
    }
  }

  Enemy buscarObjetivo(ArrayList<Enemy> enemies){
    Enemy objetivo = null;
    float mejorDistancia = 999999;
    for(Enemy e : enemies){
      if(!e.esObjetivoValido()) continue;
      float dx = x - e.x;
      float dy = y - e.y;
      float distancia = dx * dx + dy * dy;
      if(distancia < mejorDistancia){
        mejorDistancia = distancia;
        objetivo = e;
      }
    }
    return objetivo;
  }

  void display(){
    if(!activo) return;
    PImage imgActual = imgCentro;
    if(vx > 1.2 && imgDerecha != null){
      imgActual = imgDerecha;
    }else if(vx < -1.2 && imgIzquierda != null){
      imgActual = imgIzquierda;
    }

    p.pushStyle();
    if(invulnerableFrames > 0 && (frameCount / 5) % 2 == 0){
      p.tint(255, 90, 90, 170);
    }else{
      p.tint(120, 210, 255, 230);
    }
    p.imageMode(CENTER);
    if(imgActual != null){
      p.image(imgActual, x, y, 76 * escalaVisual, 76 * escalaVisual);
    }else{
      p.noStroke();
      p.fill(90, 210, 255, 230);
      p.triangle(x, y - 30, x - 24, y + 26, x + 24, y + 26);
    }
    p.noTint();
    p.noStroke();
    p.fill(40, 0, 0, 210);
    p.rect(x - 30 * escalaVisual, y + 42 * escalaVisual, 60 * escalaVisual, 5 * escalaVisual);
    p.fill(0, 220, 130, 230);
    p.rect(x - 30 * escalaVisual, y + 42 * escalaVisual, 60 * escalaVisual * (vidas / 10.0), 5 * escalaVisual);
    p.popStyle();
  }

  boolean colisiona(Bullet b){
    if(b.tipo == Bullet.TIPO_LASER_CRUCERO){
      return abs(x - b.x) < 32 && abs(y - b.y) < 82;
    }
    float dx = x - b.x;
    float dy = y - b.y;
    return dx * dx + dy * dy < 34 * 34;
  }

  boolean colisiona(Enemy e){
    float dx = x - e.x;
    float dy = y - e.y;
    float radio = e instanceof EnemyCruceroEmperador ? 220 : 58;
    return dx * dx + dy * dy < radio * radio;
  }

  boolean danio(){
    if(!activo || invulnerableFrames > 0) return false;
    vidas--;
    invulnerableFrames = 45;
    if(vidas <= 0){
      activo = false;
    }
    return true;
  }
}
