class Bullet{
  PApplet p;
  float x, y;
  PImage img;
  boolean enemigo;
  
  // TIPOS DE PROYECTILES
  static final int TIPO_MISIL = 0;
  static final int TIPO_METRALLETA = 1;
  static final int TIPO_LASER = 2;
  static final int TIPO_LASER_CRUCERO = 3;
  static final float VELOCIDAD_MISIL_JUGADOR = 36.0f;
  static final float VELOCIDAD_MISIL_ENEMIGO = 12.0f;
  static final float VELOCIDAD_LASER_JUGADOR = 48.0f;
  static final float VELOCIDAD_LASER_ENEMIGO = 18.0f;
  
  int tipo;
  float velocidad;
  float velocidadX = 0;
  float velocidadY = 0;
  float angulo = 0;
  int danio;
  float escalaVisual = 1;
  
  Bullet(PApplet p, float x, float y, int tipo, SoundManager sound){
    this(p, x, y, tipo, sound, false);
  }

  Bullet(PApplet p, float x, float y, int tipo, SoundManager sound, boolean enemigo){
    this(p, x, y, tipo, sound, enemigo, true);
  }

  Bullet(PApplet p, float x, float y, int tipo, SoundManager sound, boolean enemigo, boolean reproducirSonido){
    this.p = p;
    this.x = x;
    this.y = y;
    this.tipo = tipo;
    this.enemigo = enemigo;
    escalaVisual = constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
    
    switch(tipo){
      case TIPO_MISIL:
        img = sound.imagen("misil.png", int(30 * escalaVisual), int(45 * escalaVisual));
        velocidad = (enemigo ? VELOCIDAD_MISIL_ENEMIGO : VELOCIDAD_MISIL_JUGADOR) * escalaVisual;
        velocidadY = enemigo ? velocidad : -velocidad;
        danio = 1;
        if(reproducirSonido && !enemigo) sound.disparoMisil();
        break;
      case TIPO_METRALLETA:
        velocidad = 15 * escalaVisual;
        velocidadY = enemigo ? velocidad : -velocidad;
        danio = 1;
        if(reproducirSonido && !enemigo) sound.disparoMetralleta();
        break;
      case TIPO_LASER:
        velocidad = (enemigo ? VELOCIDAD_LASER_ENEMIGO : VELOCIDAD_LASER_JUGADOR) * escalaVisual;
        velocidadY = enemigo ? velocidad : -velocidad;
        danio = 3;
        if(reproducirSonido && !enemigo) sound.disparoLaser();
        break;
      case TIPO_LASER_CRUCERO:
        img = sound.imagen("laser_crucero.png", int(42 * escalaVisual), int(140 * escalaVisual));
        velocidad = 10 * escalaVisual;
        velocidadY = enemigo ? velocidad : -velocidad;
        danio = 2;
        break;
    }
  }

  Bullet(PApplet p, float x, float y, int tipo, SoundManager sound, boolean enemigo, boolean reproducirSonido, PImage imagenPersonalizada){
    this.p = p;
    this.x = x;
    this.y = y;
    this.tipo = tipo;
    this.enemigo = enemigo;
    img = imagenPersonalizada;
    escalaVisual = constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
    velocidad = 10 * escalaVisual;
    velocidadY = enemigo ? velocidad : -velocidad;
    danio = 2;
  }

  Bullet(PApplet p, float x, float y, int tipo, SoundManager sound, boolean enemigo, boolean reproducirSonido, PImage imagenPersonalizada, float direccionX, float direccionY){
    this(p, x, y, tipo, sound, enemigo, reproducirSonido, imagenPersonalizada);
    float magnitud = max(0.001, sqrt(direccionX * direccionX + direccionY * direccionY));
    velocidadX = direccionX / magnitud * velocidad;
    velocidadY = direccionY / magnitud * velocidad;
    angulo = atan2(velocidadX, velocidadY);
  }

  void update(){
    x += velocidadX;
    y += velocidadY;
  }
  
  boolean fuera(){
    return x < -120 || x > p.width + 120 || y < -120 || y > p.height + 120;
  }
  
  boolean colisiona(Enemy e){
    float dx = x - e.x;
    float dy = y - e.y;
    float radio;
    if(e instanceof EnemyCruceroEmperador){
      radio = 230 * escalaVisual;
    }else{
      radio = 40 * escalaVisual;
    }
    return dx * dx + dy * dy < radio * radio;
  }

  boolean colisiona(Player player){
    float dx = x - player.x;
    float dy = y - player.y;
    float radio;
    if(tipo == TIPO_LASER_CRUCERO){
      radio = 62 * escalaVisual;
    }else{
      radio = 30 * escalaVisual;
    }
    return dx * dx + dy * dy < radio * radio;
  }

  void display(){
    p.imageMode(CENTER);
    
    if(tipo == TIPO_MISIL && img != null){
      p.image(img, x, y);
    }else if(tipo == TIPO_METRALLETA){
      p.fill(255, 255, 0);
      p.ellipse(x, y, 5 * escalaVisual, 12 * escalaVisual);
    }else if(tipo == TIPO_LASER_CRUCERO){
      if(img != null){
        p.pushMatrix();
        p.translate(x, y);
        p.rotate(angulo);
        p.image(img, 0, 0);
        p.popMatrix();
      }else{
        p.pushMatrix();
        p.translate(x, y);
        p.rotate(angulo);
        p.noStroke();
        p.fill(255, 40, 30, 235);
        p.rect(-8 * escalaVisual, -54 * escalaVisual, 16 * escalaVisual, 108 * escalaVisual, 8 * escalaVisual);
        p.fill(255, 210, 70, 170);
        p.rect(-16 * escalaVisual, -54 * escalaVisual, 32 * escalaVisual, 108 * escalaVisual, 12 * escalaVisual);
        p.popMatrix();
      }
    }else if(tipo == TIPO_LASER){
      if(enemigo){
        p.noStroke();
        p.fill(255, 0, 0, 220);
        p.ellipse(x, y, 10, 10);
        p.fill(255, 80, 80, 140);
        p.ellipse(x, y, 18, 18);
      }else{
        p.noStroke();
        p.fill(0, 150, 255, 220);
        p.beginShape();
        p.vertex(x, y - 14);
        p.vertex(x - 7, y + 10);
        p.vertex(x + 7, y + 10);
        p.endShape(CLOSE);
        p.fill(80, 180, 255, 140);
        p.beginShape();
        p.vertex(x, y - 8);
        p.vertex(x - 4, y + 6);
        p.vertex(x + 4, y + 6);
        p.endShape(CLOSE);
      }
    }
  }
}
