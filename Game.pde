class Game{
  PApplet p;
  Player player;
  ArrayList<Bullet> bullets;
  ArrayList<Bullet> enemyBullets;
  ArrayList<Enemy> enemies;
  ArrayList<Explosion> explosions;
  ArrayList<EventMessage> events;
  ArrayList<SupportFighter> apoyos;
  ArrayList<PImage> spritesExplosion;
  ArrayList<PImage> spritesExplosionFinal;
  SoundManager sound;
  TouchControls controlesTactiles;
  boolean modoMovil = false;
  int cooldownRafagaTouch = 0;
  int cooldownMisilTouch = 0;
  int cooldownLaserTouch = 0;
  final int CADENCIA_RAFAGA_TOUCH = 3;
  final int CADENCIA_MISIL_TOUCH = 2;
  final int CADENCIA_LASER_TOUCH = 1;
  boolean rafagaTouchAnterior = false;
  boolean misilTouchAnterior = false;
  boolean laserTouchAnterior = false;
  boolean pausaTouchAnterior = false;
  boolean pausado = false;

  final int FASE_5_OVNIS = 0;
  final int FASE_5_NODRIZAS = 1;
  final int FASE_5_CRUCERO = 2;
  int faseNivel5 = FASE_5_OVNIS;
  int ovnisInicialesNivel5 = 0;
  int ovnisDestruidosNivel5 = 0;
  int nodrizasDestruidasNivel5 = 0;
  boolean ataqueUnoCruceroActivado = false;
  boolean ataqueDosCruceroActivado = false;
  EnemyCruceroEmperador cruceroNivel5;
  
  // ESTADOS DEL JUEGO
  final int ESTADO_REGISTRO = 0;
  final int ESTADO_INTRO = 1;
  final int ESTADO_JUGANDO = 2;
  final int ESTADO_VICTORIA = 3;
  final int ESTADO_DERROTA = 4;
  final int ESTADO_CAMBIO_NIVEL = 5;
  final int ESTADO_FINAL_CRUCERO = 6;
  final int ESTADO_FINAL_EMPERADOR = 7;
  final int ESTADO_CAIDA_EMPERADOR = 8;
  final int ESTADO_CINEMATICA_VICTORIA = 9;
  final int ESTADO_CINEMATICA_DERROTA = 10;
  final int ESTADO_CONQUISTA_EMPERADOR = 11;
  
  int estadoActual = ESTADO_REGISTRO;
  int nivelActual = 1;
  int siguienteNivel = 1;
  int enemigosDerrotados = 0;
  int totalEnemigosNivel = 0;
  int puntaje = 0;
  int bonusInicio = 500;
  int bonusPendiente = 0;
  int maxBalasJugador = 120;
  int maxExplosiones = 12;
  boolean bonusInicioEntregado = false;
  float tiempoIntro = 0;
  float tiempoEspera = 0;
  float duracionCambioNivel = 5.0;
  float tiempoFinalCrucero = 0;
  float tiempoFinalEmperador = 0;
  final float DURACION_FINAL_CRUCERO = 5.0;
  final float DURACION_FINAL_EMPERADOR = 5.0;
  float tiempoCaidaEmperador = 0;
  final float DURACION_CAIDA_EMPERADOR = 6.0;
  float tiempoCinematicaVictoria = 0;
  final float DURACION_IMAGEN_VICTORIA = 15.0;
  float tiempoCinematicaDerrota = 0;
  final float DURACION_IMAGEN_DERROTA = 5.0;
  int pulsoSonidoInvasion = -1;
  int escenaSonidoInvasion = -1;
  float tiempoConquistaEmperador = 0;
  final float DURACION_EMPERADOR_VICTORIA = 3.0;
  final float DURACION_PILOTO_RESISTENCIA = 5.0;
  String nombrePiloto = "";
  String nombreEnEdicion = "";
  
  PImage imagenIntro;
  PImage imagenComandante;
  PImage imagenEmperador;
  PImage[] fondosNivel;
  PImage[] fondosSalto;
  PImage imagenCazaIndicador;
  PImage imagenNebulosaOrigen;
  PImage imagenNebulosaDestino;
  PImage imagenCruceroFinal;
  PImage fondoCentroMando;
  PImage emperadorSentado1;
  PImage emperadorSentado2;
  PImage emperadorCorre1;
  PImage emperadorCorre2;
  PImage naveVentanaNodriza;
  PImage naveVentanaOvni;
  PImage fondoCaidaEmperador;
  PImage emperadorCaida1;
  PImage emperadorCaida2;
  PImage imagenVictoria1;
  PImage imagenVictoria2;
  PImage imagenTierraDerrota1;
  PImage imagenTierraDerrota2;
  PImage imagenEmperadorVictoria1;
  PImage imagenEmperadorVictoria2;
  PImage imagenEmperadorVictoria3;
  PImage imagenPilotoResistencia;
  PFont fontIntroBold;
  PFont fontIntroNormal;
  
  // CONFIGURACION DE NIVELES
  int[] enemigosPorNivel = {10, 15, 20, 23, 27};
  int[] vidasNivel = {10, 10, 10, 10, 10};
  String[] nombresGalaxia = {
    "",
    "Galaxia Terra",
    "Nebulosa Tharion",
    "Cinturon Zhak",
    "Sector Kor",
    "Nucleo VHAR'ZUL"
  };

  Game(PApplet p){
    this.p = p;
    sound = new SoundManager(p);
    controlesTactiles = new TouchControls(p);
    
    imagenIntro = p.loadImage("fondo_intro.png");
    if(imagenIntro != null) imagenIntro.resize(p.width, p.height);
    
    imagenComandante = p.loadImage("COMANDANTE THIAKOR GOMEZ.png");
    if(imagenComandante == null) imagenComandante = p.loadImage("COMANDANTE THIAKOR G\u00d3MEZ.png");
    if(imagenComandante != null) imagenComandante.resize(200, 200);
    
    imagenEmperador = p.loadImage("EMPERADOR VHAR_ZUL.png");
    if(imagenEmperador != null) imagenEmperador.resize(200, 200);
    
    fontIntroBold = p.createFont("SansSerif Bold", 24 * 1.3, true);
    fontIntroNormal = p.createFont("SansSerif", 24, true);

    fondosNivel = new PImage[6];
    for(int i = 1; i <= 5; i++){
      fondosNivel[i] = p.loadImage("fondo_nivel" + i + ".png");
    }

    fondosSalto = new PImage[5];
    fondosSalto[1] = p.loadImage("salto1_2.png");
    fondosSalto[2] = p.loadImage("salto2_3.png");
    fondosSalto[3] = p.loadImage("salto3_4.png");
    if(fondosSalto[3] == null) fondosSalto[3] = p.loadImage("sallto3_4.png");
    fondosSalto[4] = p.loadImage("salto4_5.png");
    imagenCazaIndicador = p.loadImage("cazaf2_centro.png");
    if(imagenCazaIndicador != null) imagenCazaIndicador.resize(54, 54);
    imagenNebulosaOrigen = p.loadImage("nebulosa_1.png");
    imagenNebulosaDestino = p.loadImage("nebulosa_2_nueva.png");
    if(imagenNebulosaDestino == null) imagenNebulosaDestino = p.loadImage("nebulosa_2.png");
    imagenCruceroFinal = p.loadImage("crucero_Emperdor.png");
    fondoCentroMando = p.loadImage("centro_mando_emperador_batalla.png");
    if(fondoCentroMando == null) fondoCentroMando = p.loadImage("centro_mando_emperador.png");
    emperadorSentado1 = p.loadImage("emperador_sentado_1.png");
    emperadorSentado2 = limpiarFondoAjedrez(p.loadImage("emperador_sentado_2.png"));
    emperadorCorre1 = limpiarFondoAjedrez(p.loadImage("emperador_corre_1.png"));
    emperadorCorre2 = limpiarFondoAjedrez(p.loadImage("emperador_corre_2.png"));
    naveVentanaNodriza = p.loadImage("nodriza.png");
    naveVentanaOvni = p.loadImage("ovnirojo.png");
    fondoCaidaEmperador = p.loadImage("cucero_z.png");
    emperadorCaida1 = limpiarFondoAjedrez(p.loadImage("emperador_caida_1.png"));
    emperadorCaida2 = p.loadImage("emperador_caida_2.png");
    imagenVictoria1 = p.loadImage("victoria_1.png");
    imagenVictoria2 = p.loadImage("victoria_2.png");
    imagenTierraDerrota1 = p.loadImage("tierra_1.png");
    imagenTierraDerrota2 = p.loadImage("tierra_2.png");
    imagenEmperadorVictoria1 = p.loadImage("emperador_victoria_1.png");
    imagenEmperadorVictoria2 = p.loadImage("emperador_victoria_2.png");
    imagenEmperadorVictoria3 = p.loadImage("emperador_vicoria_3.png");
    imagenPilotoResistencia = p.loadImage("final_piloto_pierde.png");
    
    bullets = new ArrayList<Bullet>();
    enemyBullets = new ArrayList<Bullet>();
    enemies = new ArrayList<Enemy>();
    explosions = new ArrayList<Explosion>();
    events = new ArrayList<EventMessage>();
    spritesExplosion = cargarSpritesExplosion();
    spritesExplosionFinal = cargarSpritesExplosionFinal();
    
    player = new Player(p, sound);
    apoyos = new ArrayList<SupportFighter>();
    apoyos.add(new SupportFighter(p, sound, player, -1));
    apoyos.add(new SupportFighter(p, sound, player, 1));
  }

  void activarModoMovil(){
    modoMovil = true;
    controlesTactiles.visible = false;
  }

  boolean estaEnRegistro(){
    return estadoActual == ESTADO_REGISTRO;
  }

  boolean estaEnIntro(){
    return estadoActual == ESTADO_INTRO;
  }

  boolean estaFinalizado(){
    return estadoActual == ESTADO_DERROTA || estadoActual == ESTADO_VICTORIA;
  }

  boolean estaJuegoPausado(){
    return estadoActual == ESTADO_JUGANDO && pausado;
  }

  float escalaJuego(){
    return constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
  }

  float escalaMovilUI(){
    return constrain(min(p.width, p.height) / 700.0f, 0.72f, 1.8f);
  }

  void actualizarToques(int[] ids, float[] xs, float[] ys){
    if(!modoMovil) return;
    controlesTactiles.visible = estadoActual == ESTADO_JUGANDO;
    controlesTactiles.actualizar(ids, xs, ys);
    if(estadoActual == ESTADO_JUGANDO){
      if(controlesTactiles.pausaActiva && !pausaTouchAnterior){
        cambiarPausa();
      }
      pausaTouchAnterior = controlesTactiles.pausaActiva;
    }else{
      pausaTouchAnterior = false;
      pausado = false;
      controlesTactiles.juegoPausado = false;
    }
  }

  void cambiarPausa(){
    if(estadoActual != ESTADO_JUGANDO) return;
    pausado = !pausado;
    controlesTactiles.juegoPausado = pausado;
    if(pausado){
      player.setAnalogInput(0, 0);
    }
  }

  void iniciarIntro(){
    if(nombreEnEdicion.trim().length() == 0){
      nombrePiloto = "Piloto XharKor";
    }else{
      nombrePiloto = nombreEnEdicion.trim();
    }
    tiempoIntro = 0;
    if(!bonusInicioEntregado){
      puntaje += bonusInicio;
      bonusInicioEntregado = true;
    }
    estadoActual = ESTADO_INTRO;
    sound.introduccion();
  }

  void iniciarNivel(){
    sound.detenerAudioSaltoGalactico();
    bullets.clear();
    enemyBullets.clear();
    enemies.clear();
    explosions.clear();
    events.clear();
    enemigosDerrotados = 0;
    tiempoEspera = 0;
    tiempoFinalCrucero = 0;
    tiempoFinalEmperador = 0;
    tiempoCaidaEmperador = 0;
    tiempoCinematicaVictoria = 0;
    tiempoCinematicaDerrota = 0;
    pulsoSonidoInvasion = -1;
    escenaSonidoInvasion = -1;
    tiempoConquistaEmperador = 0;
    cooldownRafagaTouch = 0;
    cooldownMisilTouch = 0;
    cooldownLaserTouch = 0;
    rafagaTouchAnterior = false;
    misilTouchAnterior = false;
    laserTouchAnterior = false;
    pausaTouchAnterior = false;
    pausado = false;
    controlesTactiles.juegoPausado = false;
    faseNivel5 = FASE_5_OVNIS;
    ovnisInicialesNivel5 = 0;
    ovnisDestruidosNivel5 = 0;
    nodrizasDestruidasNivel5 = 0;
    ataqueUnoCruceroActivado = false;
    ataqueDosCruceroActivado = false;
    cruceroNivel5 = null;
    
    player.vidas = vidasNivel[nivelActual-1];
    player.resetPos();
    for(SupportFighter apoyo : apoyos){
      apoyo.reset();
    }
    
    totalEnemigosNivel = enemigosPorNivel[nivelActual-1];
    ovnisInicialesNivel5 = nivelActual == 5 ? max(0, totalEnemigosNivel - 3) : 0;
    for(int i = 0; i < totalEnemigosNivel; i++){
      int columnas = min(10, totalEnemigosNivel);
      int fila = i / columnas;
      int columna = i % columnas;
      float espacioX = p.width / (columnas + 1.0);
      float xPos = espacioX * (columna + 1);
      float yPos = 60 * escalaJuego() + fila * 78 * escalaJuego();

      if(nivelActual == 5 && i == totalEnemigosNivel - 3){
        EnemyNodriza nodriza = new EnemyNodriza(p, p.width * 0.20, 120, sound, nivelActual, enemyBullets);
        nodriza.activoEnCombate = false;
        nodriza.invulnerable = true;
        enemies.add(nodriza);
      }else if(nivelActual == 5 && i == totalEnemigosNivel - 2){
        EnemyNodriza nodriza = new EnemyNodriza(p, p.width * 0.80, 120, sound, nivelActual, enemyBullets);
        nodriza.activoEnCombate = false;
        nodriza.invulnerable = true;
        enemies.add(nodriza);
      }else if(nivelActual == 5 && i == totalEnemigosNivel - 1){
        cruceroNivel5 = new EnemyCruceroEmperador(p, p.width / 2.0, 210, sound, nivelActual, enemyBullets);
        cruceroNivel5.activoEnCombate = false;
        cruceroNivel5.invulnerable = true;
        enemies.add(cruceroNivel5);
      }else{
        enemies.add(new EnemyNaveRoja(p, xPos, yPos, sound, nivelActual, enemyBullets));
      }
    }
    
    estadoActual = ESTADO_JUGANDO;
  }

  void reiniciarPartida(){
    nivelActual = 1;
    siguienteNivel = 1;
    puntaje = bonusInicio;
    bonusInicioEntregado = true;
    bonusPendiente = 0;
    tiempoIntro = 0;
    iniciarNivel();
  }

  boolean intentarReiniciar(float toqueX, float toqueY){
    if(!estaFinalizado()) return false;
    float espacio = 18 * escalaMovilUI();
    float panelW = min(p.width * 0.78f, 760 * escalaMovilUI());
    float botonW = (panelW - espacio) * 0.5f;
    float botonH = constrain(p.height * 0.12f, 64, 112);
    float botonX = (p.width - panelW) * 0.5f;
    float botonY = p.height * 0.68f;
    boolean dentro = dentroBoton(toqueX, toqueY, botonX, botonY, botonW, botonH);
    if(dentro) reiniciarPartida();
    return dentro;
  }

  boolean intentarAccionFinal(float toqueX, float toqueY){
    if(!estaFinalizado()) return false;
    float espacio = 18 * escalaMovilUI();
    float panelW = min(p.width * 0.78f, 760 * escalaMovilUI());
    float botonW = (panelW - espacio) * 0.5f;
    float botonH = constrain(p.height * 0.12f, 64, 112);
    float botonX = (p.width - panelW) * 0.5f;
    float botonY = p.height * 0.68f;

    if(dentroBoton(toqueX, toqueY, botonX, botonY, botonW, botonH)){
      reiniciarPartida();
      return true;
    }
    if(dentroBoton(toqueX, toqueY, botonX + botonW + espacio, botonY, botonW, botonH)){
      cerrarAplicacion();
      return true;
    }
    return false;
  }

  boolean intentarAccionPausa(float toqueX, float toqueY){
    if(!estaJuegoPausado()) return false;
    float espacio = 14 * escalaMovilUI();
    float panelW = min(p.width * 0.88f, 940 * escalaMovilUI());
    float botonW = (panelW - espacio * 2) / 3.0f;
    float botonH = constrain(p.height * 0.11f, 62, 106);
    float botonX = (p.width - panelW) * 0.5f;
    float botonY = p.height * 0.60f;

    if(dentroBoton(toqueX, toqueY, botonX, botonY, botonW, botonH)){
      cambiarPausa();
      return true;
    }
    if(dentroBoton(toqueX, toqueY, botonX + botonW + espacio, botonY, botonW, botonH)){
      reiniciarPartida();
      return true;
    }
    if(dentroBoton(toqueX, toqueY, botonX + (botonW + espacio) * 2, botonY, botonW, botonH)){
      cerrarAplicacion();
      return true;
    }
    return false;
  }

  boolean dentroBoton(float toqueX, float toqueY, float x, float y, float w, float h){
    return toqueX >= x && toqueX <= x + w && toqueY >= y && toqueY <= y + h;
  }

  void cerrarAplicacion(){
    p.exit();
  }

  void iniciarCambioNivel(){
    siguienteNivel = nivelActual + 1;
    bonusPendiente = 250 * nivelActual + player.vidas * 50;
    puntaje += bonusPendiente;
    tiempoEspera = 0;
    bullets.clear();
    enemyBullets.clear();
    enemies.clear();
    explosions.clear();
    events.clear();
    estadoActual = ESTADO_CAMBIO_NIVEL;
    sound.iniciarAudioSaltoGalactico();
  }

  void iniciarFinalCrucero(){
    tiempoFinalCrucero = 0;
    bullets.clear();
    enemyBullets.clear();
    enemies.clear();
    explosions.clear();
    events.clear();
    pausado = false;
    estadoActual = ESTADO_FINAL_CRUCERO;
  }

  void iniciarFinalEmperador(){
    tiempoFinalEmperador = 0;
    estadoActual = ESTADO_FINAL_EMPERADOR;
  }

  void iniciarCaidaEmperador(){
    tiempoCaidaEmperador = 0;
    estadoActual = ESTADO_CAIDA_EMPERADOR;
    sound.iniciarCaidaEmperador();
  }

  void iniciarCinematicaVictoria(){
    tiempoCinematicaVictoria = 0;
    estadoActual = ESTADO_CINEMATICA_VICTORIA;
    sound.iniciarMusicaVictoria();
  }

  void iniciarCinematicaDerrota(){
    if(estadoActual == ESTADO_CINEMATICA_DERROTA) return;
    tiempoCinematicaDerrota = 0;
    pulsoSonidoInvasion = -1;
    escenaSonidoInvasion = -1;
    pausado = false;
    estadoActual = ESTADO_CINEMATICA_DERROTA;
  }

  void iniciarConquistaEmperador(){
    tiempoConquistaEmperador = 0;
    estadoActual = ESTADO_CONQUISTA_EMPERADOR;
    sound.iniciarAudioVictoriaEmperador();
  }

  void update(){
    if(estadoActual == ESTADO_REGISTRO){
      return;
    }
    else if(estadoActual == ESTADO_INTRO){
      tiempoIntro += 1.0/60.0;
      if(tiempoIntro > 8.0){
        iniciarNivel();
      }
    }
    else if(estadoActual == ESTADO_JUGANDO){
      if(pausado) return;
      if(modoMovil){
        player.setAnalogInput(controlesTactiles.inputX, controlesTactiles.inputY);
      }
      player.update();
      procesarDisparosTactiles();

      for(SupportFighter apoyo : apoyos){
        apoyo.update(enemies, bullets);
      }
      
      for(int i = bullets.size()-1; i >= 0; i--){
        Bullet b = bullets.get(i);
        b.update();
        if(b.y < 0 || b.fuera()){
          bullets.remove(i);
        }
      }
      
      for(int i = enemies.size()-1; i >= 0; i--){
        Enemy e = enemies.get(i);
        e.actualizarEstadoDefensivo();
        if(e.activoEnCombate){
          e.update(player, enemyBullets);
        }else if(e instanceof EnemyCruceroEmperador){
          ((EnemyCruceroEmperador)e).updateEnEspera(player, enemyBullets);
        }
      }
      
      for(int i = enemyBullets.size()-1; i >= 0; i--){
        Bullet b = enemyBullets.get(i);
        b.update();
        if(b.fuera()) enemyBullets.remove(i);
      }

      for(int i = explosions.size()-1; i >= 0; i--){
        Explosion exp = explosions.get(i);
        exp.update();
        if(exp.terminada()) explosions.remove(i);
      }
      
      for(int i = events.size()-1; i >= 0; i--){
        EventMessage em = events.get(i);
        em.update();
        if(em.terminada()) events.remove(i);
      }
      
      for(int i = bullets.size()-1; i >= 0; i--){
        Bullet b = bullets.get(i);
        for(int j = enemies.size()-1; j >= 0; j--){
          Enemy e = enemies.get(j);
          if(b.colisiona(e)){
            bullets.remove(i);
            if(e.invulnerable){
              e.marcarImpactoBlindaje();
              break;
            }
            e.recibirDanio(b.tipo, b.danio);
            if(e.estaDestruida()){
              puntaje += puntosPorEnemigo(e);
              agregarExplosion(e.x, e.y);
              sound.explosion();
              registrarDestruccionNivel5(e);
              enemies.remove(j);
              enemigosDerrotados++;
              
              if(events.size() < 2){
                events.add(new EventMessage(p, imagenComandante, "No dejare que avances\nmalditos", 2.0f));
              }
              sound.evento();
              
              if(enemies.isEmpty()){
                if(nivelActual < 5){
                  iniciarCambioNivel();
                  sound.evento();
                  return;
                }else{
                  sound.evento();
                  iniciarFinalCrucero();
                  return;
                }
              }
            }
            break;
          }
        }
      }
      
      for(int i = enemyBullets.size()-1; i >= 0; i--){
        Bullet b = enemyBullets.get(i);
        if(b.colisiona(player)){
          enemyBullets.remove(i);
          if(player.danio()){
            agregarExplosion(player.x, player.y);
            sound.explosion();
          }
          if(player.vidas <= 0){
            iniciarCinematicaDerrota();
          }
        }else{
          for(SupportFighter apoyo : apoyos){
            if(apoyo.activo && apoyo.colisiona(b)){
              enemyBullets.remove(i);
              if(apoyo.danio()){
                agregarExplosion(apoyo.x, apoyo.y);
                sound.explosion();
              }
              break;
            }
          }
        }
      }

      for(Enemy e : enemies){
        if(e.activoEnCombate && e.colisiona(player)){
          if(player.danio()){
            agregarExplosion(player.x, player.y);
            sound.explosion();
          }
          if(player.vidas <= 0){
            iniciarCinematicaDerrota();
          }
        }
        for(SupportFighter apoyo : apoyos){
          if(e.activoEnCombate && apoyo.activo && apoyo.colisiona(e)){
            if(apoyo.danio()){
              agregarExplosion(apoyo.x, apoyo.y);
              sound.explosion();
            }
          }
        }
      }
    }
    else if(estadoActual == ESTADO_CAMBIO_NIVEL){
      tiempoEspera += 1.0/60.0;
      if(tiempoEspera >= duracionCambioNivel){
        nivelActual = siguienteNivel;
        iniciarNivel();
      }
    }
    else if(estadoActual == ESTADO_FINAL_CRUCERO){
      tiempoFinalCrucero += 1.0/60.0;
      if(tiempoFinalCrucero >= DURACION_FINAL_CRUCERO){
        tiempoFinalCrucero = DURACION_FINAL_CRUCERO;
        iniciarFinalEmperador();
      }
    }
    else if(estadoActual == ESTADO_FINAL_EMPERADOR){
      tiempoFinalEmperador += 1.0/60.0;
      if(tiempoFinalEmperador >= DURACION_FINAL_EMPERADOR){
        tiempoFinalEmperador = DURACION_FINAL_EMPERADOR;
        iniciarCaidaEmperador();
      }
    }
    else if(estadoActual == ESTADO_CAIDA_EMPERADOR){
      tiempoCaidaEmperador += 1.0/60.0;
      if(tiempoCaidaEmperador >= DURACION_CAIDA_EMPERADOR){
        tiempoCaidaEmperador = DURACION_CAIDA_EMPERADOR;
        sound.detenerCaidaEmperador();
        iniciarCinematicaVictoria();
      }
    }
    else if(estadoActual == ESTADO_CINEMATICA_VICTORIA){
      tiempoCinematicaVictoria += 1.0/60.0;
      if(tiempoCinematicaVictoria >= DURACION_IMAGEN_VICTORIA * 2.0f){
        tiempoCinematicaVictoria = DURACION_IMAGEN_VICTORIA * 2.0f;
        sound.detenerMusicaVictoria();
        estadoActual = ESTADO_VICTORIA;
      }
    }
    else if(estadoActual == ESTADO_CINEMATICA_DERROTA){
      tiempoCinematicaDerrota += 1.0/60.0;
      actualizarSonidosInvasion();
      if(tiempoCinematicaDerrota >= DURACION_IMAGEN_DERROTA * 2.0f){
        tiempoCinematicaDerrota = DURACION_IMAGEN_DERROTA * 2.0f;
        iniciarConquistaEmperador();
      }
    }
    else if(estadoActual == ESTADO_CONQUISTA_EMPERADOR){
      tiempoConquistaEmperador += 1.0/60.0;
      float duracionTotal = DURACION_EMPERADOR_VICTORIA * 3.0f + DURACION_PILOTO_RESISTENCIA;
      if(tiempoConquistaEmperador >= duracionTotal){
        tiempoConquistaEmperador = duracionTotal;
        sound.detenerAudioVictoriaEmperador();
        estadoActual = ESTADO_DERROTA;
      }
    }
  }

  void display(){
    if(estadoActual == ESTADO_REGISTRO){
      displayRegistro();
    }
    else if(estadoActual == ESTADO_INTRO){
      displayIntro();
    }
    else if(estadoActual == ESTADO_JUGANDO){
      displayJuego();
    }
    else if(estadoActual == ESTADO_CAMBIO_NIVEL){
      displayCambioNivel();
    }
    else if(estadoActual == ESTADO_FINAL_CRUCERO){
      displayFinalCrucero();
    }
    else if(estadoActual == ESTADO_FINAL_EMPERADOR){
      displayFinalEmperador();
    }
    else if(estadoActual == ESTADO_CAIDA_EMPERADOR){
      displayCaidaEmperador();
    }
    else if(estadoActual == ESTADO_CINEMATICA_VICTORIA){
      displayCinematicaVictoria();
    }
    else if(estadoActual == ESTADO_CINEMATICA_DERROTA){
      displayCinematicaDerrota();
    }
    else if(estadoActual == ESTADO_CONQUISTA_EMPERADOR){
      displayConquistaEmperador();
    }
    else if(estadoActual == ESTADO_VICTORIA){
      displayVictoria();
    }
    else if(estadoActual == ESTADO_DERROTA){
      displayDerrota();
    }
  }

  void displayRegistro(){
    if(modoMovil){
      displayRegistroMovil();
      return;
    }
    dibujarFondoBase();
    p.fill(0, 180);
    p.rect(0, 0, p.width, p.height);

    p.textAlign(CENTER, CENTER);
    p.textFont(fontIntroBold);
    p.textSize(46);
    p.fill(255, 215, 0);
    p.text("REGISTRO DE PILOTO", p.width / 2.0, p.height * 0.24);

    p.textFont(fontIntroNormal);
    p.textSize(22);
    p.fill(220);
    p.text("Escribe tu nombre y presiona ENTER para iniciar la mision", p.width / 2.0, p.height * 0.32);

    float cajaW = min(620, p.width - 80);
    float cajaH = 74;
    float cajaX = p.width / 2.0 - cajaW / 2.0;
    float cajaY = p.height * 0.42;
    p.noStroke();
    p.fill(8, 18, 40, 230);
    p.rect(cajaX, cajaY, cajaW, cajaH, 8);
    p.stroke(0, 210, 255);
    p.strokeWeight(2);
    p.noFill();
    p.rect(cajaX, cajaY, cajaW, cajaH, 8);

    String cursor = (frameCount / 30) % 2 == 0 ? "_" : "";
    String textoNombre = nombreEnEdicion.length() == 0 ? "Nombre del piloto" : nombreEnEdicion + cursor;
    p.textFont(fontIntroBold);
    p.textSize(30);
    p.fill(nombreEnEdicion.length() == 0 ? p.color(120) : p.color(255));
    p.text(textoNombre, p.width / 2.0, cajaY + cajaH / 2.0);

    p.textFont(fontIntroNormal);
    p.textSize(18);
    p.fill(180, 230, 255);
    p.text("Bonus de inicio: +" + bonusInicio + " puntos | BACKSPACE borra | ENTER confirma", p.width / 2.0, cajaY + 120);
  }
  
  void displayIntro(){
    if(modoMovil){
      displayIntroMovil();
      return;
    }
    dibujarFondoBase();
    
    p.fill(255, 215, 0);
    p.textFont(fontIntroBold);
    p.textSize(24 * 1.3);
    p.textAlign(CENTER, CENTER);
    p.textLeading(36);
    
    float yOffset = 95;
    String[] textos = {
      "A\u00d1O 2147",
      "",
      "La raza Xhar'Kor ha iniciado la invasion de la Tierra.",
      "",
      "Miles de naves enemigas avanzan hacia nuestro planeta.",
      "",
      "La ultima esperanza de la humanidad descansa en " + nombrePiloto + ".",
      "",
      "Comandante Thiakor Gomez...",
      "",
      "Despegue inmediato.",
      "",
      "La batalla final ha comenzado.",
      "",
      "Presiona ENTER para comenzar.",
      "",
      "\"Cuando la Tierra cayo... un piloto se levanto.\""
    };
    
    for(String texto : textos){
      p.text(texto, p.width / 2.0, yOffset);
      yOffset += 38;
    }

    p.textFont(fontIntroNormal);
  }
  
  void displayJuego(){
    dibujarFondoBase();
    
    player.display();
    for(SupportFighter apoyo : apoyos){
      apoyo.display();
    }
    
    for(Bullet b : bullets) b.display();
    for(Bullet b : enemyBullets) b.display();
    for(Enemy e : enemies) e.display();
    for(Explosion exp : explosions) exp.display();
    for(EventMessage em : events) em.display();
    
    displayHUD();
    displayFaseNivel5();
    if(modoMovil){
      controlesTactiles.display();
    }
    if(pausado) displayPausa();
  }

  void displayPausa(){
    p.pushStyle();
    p.noStroke();
    p.fill(0, 190);
    p.rect(0, 0, p.width, p.height);
    p.textAlign(CENTER, CENTER);
    p.textFont(fontIntroBold);
    p.textSize(constrain(p.height * 0.075f, 34, 72));
    p.fill(70, 210, 255);
    p.text("JUEGO EN PAUSA", p.width * 0.5f, p.height * 0.36f);
    p.textFont(fontIntroNormal);
    p.textSize(constrain(p.height * 0.030f, 17, 30));
    p.fill(235);
    p.text("Selecciona una opcion", p.width * 0.5f, p.height * 0.48f);

    float espacio = 14 * escalaMovilUI();
    float panelW = min(p.width * 0.88f, 940 * escalaMovilUI());
    float botonW = (panelW - espacio * 2) / 3.0f;
    float botonH = constrain(p.height * 0.11f, 62, 106);
    float botonX = (p.width - panelW) * 0.5f;
    float botonY = p.height * 0.60f;
    dibujarBotonMenu("CONTINUAR", botonX, botonY, botonW, botonH, false);
    dibujarBotonMenu("REINICIAR", botonX + botonW + espacio, botonY, botonW, botonH, false);
    dibujarBotonMenu("CERRAR APP", botonX + (botonW + espacio) * 2, botonY, botonW, botonH, true);
    p.popStyle();
  }

  void displayFaseNivel5(){
    if(nivelActual != 5 || estadoActual != ESTADO_JUGANDO) return;

    String textoFase;
    if(faseNivel5 == FASE_5_OVNIS){
      int restantes = max(0, ovnisInicialesNivel5 - ovnisDestruidosNivel5);
      textoFase = "FASE 1: OVNIS RESTANTES " + restantes;
    }else if(faseNivel5 == FASE_5_NODRIZAS){
      textoFase = ataqueDosCruceroActivado
        ? "FASE 2: NODRIZAS - CRUCERO INTENSIFICADO"
        : "FASE 2: DESTRUYE LAS NAVES NODRIZA";
    }else{
      textoFase = "FASE FINAL: CRUCERO VULNERABLE";
    }

    p.pushStyle();
    p.textAlign(CENTER, TOP);
    p.textFont(fontIntroBold);
    p.textSize(constrain(p.height * 0.024f, 14, 24));
    p.noStroke();
    p.fill(0, 185);
    float panelW = min(p.width * 0.48f, 620);
    p.rect(p.width * 0.5f - panelW * 0.5f, p.height * 0.13f, panelW, p.height * 0.055f, 8);
    p.fill(faseNivel5 == FASE_5_CRUCERO ? p.color(255, 90, 55) : p.color(255, 215, 0));
    p.text(textoFase, p.width * 0.5f, p.height * 0.142f);
    p.popStyle();
  }

  void displayCambioNivel(){
    dibujarFondoSalto();
    p.noStroke();
    p.fill(0, 150);
    p.rect(0, 0, p.width, p.height);

    float progreso = constrain(tiempoEspera / duracionCambioNivel, 0, 1);
    int cuenta = max(1, ceil(duracionCambioNivel - tiempoEspera));

    p.textAlign(CENTER, CENTER);
    p.textFont(fontIntroBold);
    p.textSize(46);
    p.fill(255, 215, 0);
    p.text("SALTO HIPERGALACTICO", p.width / 2.0, p.height * 0.22);

    p.textSize(25);
    p.fill(255);
    p.text("CAMBIO DE GALAXIA", p.width / 2.0, p.height * 0.30);
    p.text(nombresGalaxia[nivelActual] + "  >  " + nombresGalaxia[siguienteNivel], p.width / 2.0, p.height * 0.36);

    dibujarRutaGalaxia(progreso);

    float barraW = min(760, p.width - 120);
    float barraH = 22;
    float barraX = p.width / 2.0 - barraW / 2.0;
    float barraY = p.height * 0.64;
    p.noStroke();
    p.fill(25, 35, 65);
    p.rect(barraX, barraY, barraW, barraH, 6);
    p.fill(0, 210, 255);
    p.rect(barraX, barraY, barraW * progreso, barraH, 6);

    p.textFont(fontIntroNormal);
    p.textSize(22);
    p.fill(220);
    p.text("Avance hiperespacial: " + int(progreso * 100) + "%", p.width / 2.0, barraY + 58);
    p.text("Nuevo nivel en " + cuenta + " segundos", p.width / 2.0, barraY + 92);
    p.text("Bonus de sector: +" + bonusPendiente + " | Puntaje: " + puntaje, p.width / 2.0, barraY + 126);

    displayHUDCompacto();
  }
  
  void displayHUD(){
    if(modoMovil){
      displayHUDMovil();
      return;
    }
    p.pushStyle();
    p.noStroke();
    p.fill(0, 165);
    p.rect(12, 12, 390, 104, 8);
    p.rect(p.width - 405, 12, 393, 84, 8);

    p.textFont(fontIntroNormal);
    p.textSize(18);
    p.textAlign(LEFT, TOP);
    p.fill(255);
    p.text("Piloto: " + nombrePiloto, 28, 24);
    p.text("Puntaje: " + puntaje, 28, 50);
    p.text("Galaxia: " + nivelActual + "/5 - " + nombresGalaxia[nivelActual], 28, 76);

    p.textAlign(RIGHT, TOP);
    p.text("E: Misil | W: Metralleta | Q: Laser", p.width - 28, 24);
    p.text("Flechas: mover caza", p.width - 28, 50);

    p.textAlign(LEFT, TOP);
    float panelX = 28;
    float panelY = 122;
    p.fill(0, 165);
    p.rect(12, 110, 390, 82, 8);
    p.fill(255);
    p.text("Estado del caza: " + estadoCaza(), panelX, panelY);
    p.text("Vidas: " + player.vidas + "/" + vidasNivel[nivelActual-1], panelX, panelY + 24);
    p.text("Enemigos: " + enemigosDerrotados + "/" + totalEnemigosNivel, panelX, panelY + 48);
    dibujarBarraIntegridad(panelX + 162, panelY + 30, 190, 14);

    p.fill(0, 165);
    p.rect(12, 200, 390, 56, 8);
    p.fill(255);
    p.text("Cazas de apoyo: " + estadoApoyos(), 28, 214);
    p.text("Ataque automatico activo", 28, 238);
    p.popStyle();
  }

  void displayHUDCompacto(){
    if(modoMovil){
      displayHUDMovil();
      return;
    }
    p.pushStyle();
    p.noStroke();
    p.fill(0, 150);
    p.rect(18, p.height - 112, 380, 86, 8);
    p.textFont(fontIntroNormal);
    p.textSize(18);
    p.textAlign(LEFT, TOP);
    p.fill(255);
    p.text("Piloto: " + nombrePiloto, 34, p.height - 98);
    p.text("Caza: " + estadoCaza(), 34, p.height - 72);
    p.text("Vidas: " + player.vidas + "/" + vidasNivel[nivelActual-1], 34, p.height - 46);
    p.popStyle();
  }

  void displayFinalCrucero(){
    p.pushStyle();
    p.imageMode(CORNER);
    PImage fondo = fondosNivel[5];
    if(fondo != null) p.image(fondo, 0, 0, p.width, p.height);
    else p.background(0);

    float progreso = constrain(tiempoFinalCrucero / DURACION_FINAL_CRUCERO, 0, 1);
    float anchoCrucero = min(p.width * 0.64f, p.height * 1.08f);
    float altoCrucero = anchoCrucero * 0.6667f;
    float temblor = pow(progreso, 1.7f) * 11.0f;
    float centroX = p.width * 0.5f + sin(tiempoFinalCrucero * 37.0f) * temblor;
    float centroY = p.height * 0.45f + cos(tiempoFinalCrucero * 31.0f) * temblor * 0.55f;
    float escalaRuptura = 1.0f + max(0, progreso - 0.62f) * 0.22f;
    float alphaCrucero = progreso < 0.80f ? 255 : map(progreso, 0.80f, 1.0f, 255, 0);

    if(imagenCruceroFinal != null){
      p.imageMode(CENTER);
      p.tint(255, alphaCrucero);
      p.image(imagenCruceroFinal, centroX, centroY,
        anchoCrucero * escalaRuptura, altoCrucero * escalaRuptura);
      p.noTint();
    }

    float[] inicios = {0.15f, 0.55f, 1.05f, 1.50f, 2.00f, 2.45f, 2.90f, 3.30f, 3.65f, 4.00f};
    float[] posicionesX = {-0.25f, 0.23f, -0.08f, 0.30f, -0.31f, 0.10f, -0.18f, 0.27f, -0.03f, 0.0f};
    float[] posicionesY = {-0.14f, -0.11f, 0.10f, 0.13f, 0.04f, -0.20f, 0.19f, 0.01f, -0.02f, 0.0f};
    for(int i = 0; i < inicios.length; i++){
      float tamano = i == inicios.length - 1
        ? min(p.width, p.height) * 0.72f
        : min(p.width, p.height) * (0.24f + (i % 3) * 0.035f);
      dibujarExplosionFinal(tiempoFinalCrucero - inicios[i],
        centroX + posicionesX[i] * anchoCrucero,
        centroY + posicionesY[i] * altoCrucero, tamano);
    }

    if(progreso > 0.82f){
      float destello = 210 * sin(map(progreso, 0.82f, 1.0f, 0, PI));
      p.noStroke();
      p.fill(255, 190, 90, destello);
      p.rectMode(CORNER);
      p.rect(0, 0, p.width, p.height);
    }
    p.popStyle();
  }

  void displayFinalEmperador(){
    p.pushStyle();
    float progreso = constrain(tiempoFinalEmperador / DURACION_FINAL_EMPERADOR, 0, 1);
    float temblor = progreso < 0.36f ? 0 : map(progreso, 0.36f, 1.0f, 1.5f, 13.0f);
    float sacudidaX = sin(tiempoFinalEmperador * 39.0f) * temblor;
    float sacudidaY = cos(tiempoFinalEmperador * 33.0f) * temblor * 0.55f;

    p.imageMode(CORNER);
    if(fondoCentroMando != null){
      p.image(fondoCentroMando, sacudidaX - temblor, sacudidaY - temblor,
        p.width + temblor * 2, p.height + temblor * 2);
    }else{
      p.background(8, 0, 0);
    }

    float centroX = p.width * 0.5f + sacudidaX;
    float baseY = p.height * 0.92f + sacudidaY;
    dibujarExplosionFinal(tiempoFinalEmperador - 2.05f, p.width * 0.27f, p.height * 0.69f, min(p.width, p.height) * 0.38f);
    dibujarExplosionFinal(tiempoFinalEmperador - 2.55f, p.width * 0.74f, p.height * 0.66f, min(p.width, p.height) * 0.42f);

    float alphaSentado1 = 255 * (1.0f - smoothstep(1.20f, 1.70f, tiempoFinalEmperador));
    float alphaSentado2 = 255 * smoothstep(1.20f, 1.70f, tiempoFinalEmperador)
      * (1.0f - smoothstep(2.05f, 2.35f, tiempoFinalEmperador));
    dibujarEmperadorEscena(emperadorSentado1, centroX, baseY, p.height * 0.73f, alphaSentado1);
    dibujarEmperadorEscena(emperadorSentado2, centroX, baseY, p.height * 0.73f, alphaSentado2);
    if(tiempoFinalEmperador >= 2.05f){
      float avance = smoothstep(2.05f, 4.85f, tiempoFinalEmperador);
      PImage cuadroCarrera = int((tiempoFinalEmperador - 2.05f) / 0.16f) % 2 == 0
        ? emperadorCorre1 : emperadorCorre2;
      float corredorX = lerp(p.width * 0.50f, p.width * 1.08f, avance);
      float corredorY = p.height * 0.91f + sin(tiempoFinalEmperador * 19.0f) * p.height * 0.010f;
      float altoCorredor = lerp(p.height * 0.61f, p.height * 0.52f, avance);
      dibujarEmperadorCorriendo(cuadroCarrera, corredorX, corredorY,
        altoCorredor, 255, sin(tiempoFinalEmperador * 13.0f) * 0.025f);
    }

    dibujarExplosionFinal(tiempoFinalEmperador - 3.05f, centroX - p.width * 0.13f, p.height * 0.55f, min(p.width, p.height) * 0.43f);
    dibujarExplosionFinal(tiempoFinalEmperador - 3.45f, centroX + p.width * 0.14f, p.height * 0.48f, min(p.width, p.height) * 0.48f);
    dibujarExplosionFinal(tiempoFinalEmperador - 3.85f, p.width * 0.63f, p.height * 0.50f, min(p.width, p.height) * 0.68f);

    if(progreso > 0.76f){
      float destello = 225 * sin(map(progreso, 0.76f, 1.0f, 0, PI));
      p.noStroke();
      p.fill(255, 105, 35, destello);
      p.rectMode(CORNER);
      p.rect(0, 0, p.width, p.height);
    }
    p.popStyle();
  }

  void dibujarBatallaVentana(float x, float y, float ancho, float alto,
    PImage nave, boolean invertir, float retrasoExplosion){
    p.clip(x, y, ancho, alto);
    p.imageMode(CORNER);
    if(fondosNivel[5] != null){
      p.tint(105, 125, 165, 235);
      p.image(fondosNivel[5], x, y, ancho, alto);
      p.noTint();
    }else{
      p.noStroke();
      p.fill(3, 4, 12);
      p.rect(x, y, ancho, alto);
    }
    if(nave != null){
      float progresoNave = constrain(tiempoFinalEmperador / DURACION_FINAL_EMPERADOR, 0, 1);
      float naveX = invertir ? x + ancho * (0.78f - progresoNave * 0.30f) : x + ancho * (0.25f + progresoNave * 0.28f);
      float naveY = y + alto * (0.43f + sin(tiempoFinalEmperador * 2.4f) * 0.09f);
      float tamanoNave = min(ancho, alto) * 0.42f;
      p.imageMode(CENTER);
      p.image(nave, naveX, naveY, tamanoNave, tamanoNave);
      dibujarExplosionFinal(tiempoFinalEmperador - retrasoExplosion, naveX, naveY, tamanoNave * 1.15f);
      dibujarExplosionFinal(tiempoFinalEmperador - retrasoExplosion - 1.25f,
        naveX - ancho * 0.12f, naveY + alto * 0.10f, tamanoNave * 0.85f);
    }
    p.noClip();
    p.noFill();
    p.stroke(180, 35, 20, 180);
    p.strokeWeight(2);
    p.rect(x, y, ancho, alto);
  }

  void dibujarEmperadorCorriendo(PImage imagen, float x, float baseY,
    float alto, float alpha, float angulo){
    if(imagen == null || alpha <= 0) return;
    float ancho = alto * imagen.width / (float)imagen.height;
    p.pushMatrix();
    p.translate(x, baseY - alto * 0.5f);
    p.rotate(angulo);
    p.imageMode(CENTER);
    p.tint(255, constrain(alpha, 0, 255));
    p.image(imagen, 0, 0, ancho, alto);
    p.noTint();
    p.popMatrix();
  }

  void displayCaidaEmperador(){
    p.pushStyle();
    p.imageMode(CORNER);
    if(fondoCaidaEmperador != null) p.image(fondoCaidaEmperador, 0, 0, p.width, p.height);
    else p.background(0);

    float progreso = constrain(tiempoCaidaEmperador / DURACION_CAIDA_EMPERADOR, 0, 1);
    PImage pose = int(tiempoCaidaEmperador / 0.20f) % 2 == 0 ? emperadorCaida1 : emperadorCaida2;
    if(pose == null) pose = emperadorCaida1;
    float caidaSuave = smoothstep(0, 1, progreso);
    float alto = lerp(p.height * 0.72f, p.height * 0.09f, pow(caidaSuave, 0.88f));
    float ancho = pose == null ? alto * 0.67f : alto * pose.width / (float)pose.height;
    float x = p.width * 0.5f + sin(tiempoCaidaEmperador * 4.8f) * p.width * 0.035f * (1.0f - progreso);
    float y = lerp(p.height * 0.34f, p.height * 0.69f, caidaSuave);
    float angulo = sin(tiempoCaidaEmperador * 5.2f) * (0.12f + progreso * 0.30f);
    if(pose != null){
      p.pushMatrix();
      p.translate(x, y);
      p.rotate(angulo);
      p.imageMode(CENTER);
      p.tint(255, lerp(255, 185, progreso));
      p.image(pose, 0, 0, ancho, alto);
      p.noTint();
      p.popMatrix();
    }
    p.popStyle();
  }

  void displayConquistaEmperador(){
    p.pushStyle();
    int segmento;
    float tiempoSegmento;
    float duracionSegmento;
    PImage imagen;
    if(tiempoConquistaEmperador < DURACION_EMPERADOR_VICTORIA){
      segmento = 0;
      tiempoSegmento = tiempoConquistaEmperador;
      duracionSegmento = DURACION_EMPERADOR_VICTORIA;
      imagen = imagenEmperadorVictoria1;
    }else if(tiempoConquistaEmperador < DURACION_EMPERADOR_VICTORIA * 2.0f){
      segmento = 1;
      tiempoSegmento = tiempoConquistaEmperador - DURACION_EMPERADOR_VICTORIA;
      duracionSegmento = DURACION_EMPERADOR_VICTORIA;
      imagen = imagenEmperadorVictoria2;
    }else if(tiempoConquistaEmperador < DURACION_EMPERADOR_VICTORIA * 3.0f){
      segmento = 2;
      tiempoSegmento = tiempoConquistaEmperador - DURACION_EMPERADOR_VICTORIA * 2.0f;
      duracionSegmento = DURACION_EMPERADOR_VICTORIA;
      imagen = imagenEmperadorVictoria3;
    }else{
      segmento = 3;
      tiempoSegmento = tiempoConquistaEmperador - DURACION_EMPERADOR_VICTORIA * 3.0f;
      duracionSegmento = DURACION_PILOTO_RESISTENCIA;
      imagen = imagenPilotoResistencia;
    }

    float progreso = constrain(tiempoSegmento / duracionSegmento, 0, 1);
    float zoom = 1.0f + progreso * 0.035f;
    p.imageMode(CENTER);
    if(imagen != null){
      p.image(imagen, p.width * 0.5f, p.height * 0.5f,
        p.width * zoom, p.height * zoom);
    }else{
      p.background(0);
    }

    float fundidoEntrada = constrain(tiempoSegmento / 0.28f, 0, 1);
    float fundidoSalida = constrain((duracionSegmento - tiempoSegmento) / 0.28f, 0, 1);
    float visibilidad = min(fundidoEntrada, fundidoSalida);
    p.noStroke();
    p.fill(0, 255 * (1.0f - visibilidad));
    p.rectMode(CORNER);
    p.rect(0, 0, p.width, p.height);

    if(segmento == 3){
      float alphaTexto = 255 * smoothstep(0.35f, 1.15f, tiempoSegmento);
      float panelX = p.width * 0.50f;
      float panelY = p.height * 0.57f;
      float panelW = p.width * 0.46f;
      float panelH = p.height * 0.29f;
      p.fill(2, 12, 28, alphaTexto * 0.82f);
      p.stroke(50, 205, 255, alphaTexto);
      p.strokeWeight(3);
      p.rect(panelX, panelY, panelW, panelH, 16);
      p.noStroke();
      p.fill(225, 245, 255, alphaTexto);
      p.textFont(fontIntroBold);
      p.textSize(constrain(p.height * 0.031f, 18, 32));
      p.textAlign(CENTER, CENTER);
      p.textLeading(constrain(p.height * 0.046f, 28, 45));
    String promesa =
      "\"La Tierra ha caido... pero la esperanza no.\n" +
      "Mientras siga con vida, reunire a los supervivientes.\n" +
      "Volvere por nuestro hogar. La Tierra sera libre otra vez.\"\n\n" +
      "- " + nombrePiloto;
      p.text(promesa, panelX + 18, panelY + 14, panelW - 36, panelH - 28);
    }
    p.popStyle();
  }

  void actualizarSonidosInvasion(){
    int escena = min(1, int(tiempoCinematicaDerrota / DURACION_IMAGEN_DERROTA));
    if(escena != escenaSonidoInvasion){
      escenaSonidoInvasion = escena;
      sound.iniciarSonidosInvasion();
    }
    int pulso = int(tiempoCinematicaDerrota * 4.0f);
    if(pulso != pulsoSonidoInvasion){
      pulsoSonidoInvasion = pulso;
      sound.ataqueSonoroInvasion(pulso);
    }
  }

  void displayCinematicaDerrota(){
    p.pushStyle();
    boolean segundaEscena = tiempoCinematicaDerrota >= DURACION_IMAGEN_DERROTA;
    float tiempoEscena = segundaEscena
      ? tiempoCinematicaDerrota - DURACION_IMAGEN_DERROTA
      : tiempoCinematicaDerrota;
    PImage fondo = segundaEscena ? imagenTierraDerrota2 : imagenTierraDerrota1;
    p.imageMode(CORNER);
    if(fondo != null) p.image(fondo, 0, 0, p.width, p.height);
    else p.background(0);

    float deriva = segundaEscena ? 1.0f : 0.0f;
    float cruceroX = p.width * (0.50f + sin(tiempoEscena * 0.72f) * 0.055f);
    float cruceroY = p.height * (0.16f + cos(tiempoEscena * 0.93f) * 0.018f);
    dibujarNaveInvasion(imagenCruceroFinal, cruceroX, cruceroY,
      p.width * 0.36f, p.height * 0.24f, sin(tiempoEscena * 0.65f) * 0.025f);

    float nodriza1X = p.width * (0.18f + tiempoEscena * 0.018f);
    float nodriza2X = p.width * (0.82f - tiempoEscena * 0.020f);
    float nodrizaY = p.height * (0.27f + deriva * 0.05f);
    dibujarNaveInvasion(naveVentanaNodriza, nodriza1X,
      nodrizaY + sin(tiempoEscena * 1.6f) * 12, p.width * 0.15f, p.width * 0.15f, 0.08f);
    dibujarNaveInvasion(naveVentanaNodriza, nodriza2X,
      nodrizaY + cos(tiempoEscena * 1.45f) * 12, p.width * 0.15f, p.width * 0.15f, -0.08f);

    int totalOvnis = segundaEscena ? 7 : 5;
    for(int i = 0; i < totalOvnis; i++){
      float fila = i % 2;
      float ovniX = (p.width * (0.10f + i * 0.135f) + tiempoEscena * p.width * (0.025f + fila * 0.012f)) % (p.width * 1.05f);
      float ovniY = p.height * (0.35f + fila * 0.10f) + sin(tiempoEscena * 2.2f + i) * 9;
      dibujarNaveInvasion(naveVentanaOvni, ovniX, ovniY,
        p.width * 0.075f, p.width * 0.075f, sin(tiempoEscena * 2.0f + i) * 0.10f);
    }

    float objetivo1X = p.width * (segundaEscena ? 0.42f : 0.36f);
    float objetivo1Y = p.height * (segundaEscena ? 0.63f : 0.58f);
    float objetivo2X = p.width * (segundaEscena ? 0.67f : 0.61f);
    float objetivo2Y = p.height * (segundaEscena ? 0.72f : 0.66f);
    dibujarRayoInvasion(cruceroX, cruceroY + p.height * 0.08f,
      objetivo1X, objetivo1Y, p.color(255, 35, 20), tiempoEscena * 8.0f);
    dibujarRayoInvasion(nodriza1X, nodrizaY,
      objetivo2X, objetivo2Y, p.color(255, 90, 25), tiempoEscena * 10.0f + 1);
    dibujarRayoInvasion(nodriza2X, nodrizaY,
      p.width * 0.52f, p.height * 0.70f, p.color(255, 55, 25), tiempoEscena * 9.0f + 2);

    dibujarExplosionFinal((tiempoEscena + 0.10f) % 1.35f,
      objetivo1X, objetivo1Y, min(p.width, p.height) * (segundaEscena ? 0.30f : 0.23f));
    dibujarExplosionFinal((tiempoEscena + 0.62f) % 1.35f,
      objetivo2X, objetivo2Y, min(p.width, p.height) * (segundaEscena ? 0.28f : 0.21f));
    dibujarExplosionFinal((tiempoEscena + 1.02f) % 1.35f,
      p.width * 0.52f, p.height * 0.70f, min(p.width, p.height) * (segundaEscena ? 0.32f : 0.20f));
    p.popStyle();
  }

  void dibujarNaveInvasion(PImage imagen, float x, float y,
    float ancho, float alto, float angulo){
    if(imagen == null) return;
    p.pushMatrix();
    p.translate(x, y);
    p.rotate(angulo);
    p.imageMode(CENTER);
    p.image(imagen, 0, 0, ancho, alto);
    p.popMatrix();
  }

  void dibujarRayoInvasion(float origenX, float origenY,
    float destinoX, float destinoY, int colorRayo, float fase){
    float pulso = 0.45f + 0.55f * abs(sin(fase));
    p.stroke(colorRayo, 55 * pulso);
    p.strokeWeight(12 * pulso);
    p.line(origenX, origenY, destinoX, destinoY);
    p.stroke(colorRayo, 220 * pulso);
    p.strokeWeight(3.5f * pulso);
    p.line(origenX, origenY, destinoX, destinoY);
    p.noStroke();
    p.fill(255, 210, 120, 230 * pulso);
    p.ellipse(destinoX, destinoY, 14 + 12 * pulso, 14 + 12 * pulso);
  }

  void displayCinematicaVictoria(){
    p.pushStyle();
    boolean segundaParte = tiempoCinematicaVictoria >= DURACION_IMAGEN_VICTORIA;
    float tiempoParte = segundaParte
      ? tiempoCinematicaVictoria - DURACION_IMAGEN_VICTORIA
      : tiempoCinematicaVictoria;
    PImage imagen = segundaParte ? imagenVictoria2 : imagenVictoria1;
    p.imageMode(CORNER);
    if(imagen != null) p.image(imagen, 0, 0, p.width, p.height);
    else p.background(0);

    p.noStroke();
    p.fill(0, 118);
    p.rect(0, 0, p.width, p.height);

    String[] textoBatalla = {
      "LA ULTIMA BATALLA",
      "",
      "Cuando la Tierra estuvo al borde de caer,",
      "el joven piloto " + nombrePiloto + " alzo el vuelo.",
      "Reunio a los cazas supervivientes",
      "y lidero el ataque contra la flota Xhar'Kor.",
      "Atravesando fuego y oscuridad,",
      "alcanzo el crucero del emperador Vhar-Zul.",
      "Alli termino el reinado del tirano."
    };
    String[] textoAmanecer = {
      "UN NUEVO AMANECER",
      "",
      "Sin su emperador, la armada invasora huyo.",
      "La Tierra contemplo por fin un cielo libre.",
      nombrePiloto + " regreso al frente de su escuadron,",
      "recibido como simbolo de valor y esperanza.",
      "Desde aquel dia, en todos los mundos libres,",
      "las estrellas recordaron el nombre",
      "del piloto que salvo a la humanidad."
    };
    dibujarTextoCinematografico(segundaParte ? textoAmanecer : textoBatalla, tiempoParte);
    p.popStyle();
  }

  void dibujarTextoCinematografico(String[] lineas, float tiempoParte){
    float progreso = constrain(tiempoParte / DURACION_IMAGEN_VICTORIA, 0, 1);
    float separacion = p.height * 0.092f;
    float yBase = lerp(p.height * 1.10f, -p.height * 0.58f, progreso);
    p.textAlign(CENTER, CENTER);
    p.textFont(fontIntroBold);
    for(int i = 0; i < lineas.length; i++){
      float y = yBase + i * separacion;
      if(y < -separacion || y > p.height + separacion) continue;
      float perspectiva = constrain(map(y, p.height * 0.08f, p.height, 0.52f, 1.14f), 0.48f, 1.16f);
      float alphaBorde = min(
        constrain(map(y, 0, p.height * 0.20f, 0, 255), 0, 255),
        constrain(map(y, p.height, p.height * 0.78f, 0, 255), 0, 255)
      );
      float tamanoBase = i == 0 ? p.height * 0.052f : p.height * 0.034f;
      p.textSize(constrain(tamanoBase * perspectiva, 16, 52));
      p.fill(0, alphaBorde * 0.75f);
      p.text(lineas[i], p.width * 0.5f + 3, y + 4);
      p.fill(255, 215, 70, alphaBorde);
      p.text(lineas[i], p.width * 0.5f, y);
    }
  }

  void dibujarExplosionFinal(float edad, float x, float y, float tamanoBase){
    if(edad < 0 || edad > 1.35f || spritesExplosionFinal == null || spritesExplosionFinal.size() == 0) return;
    float vida = constrain(edad / 1.35f, 0, 1);
    int frameExplosion = int(edad / 0.16f) % spritesExplosionFinal.size();
    float entrada = constrain(edad / 0.12f, 0, 1);
    float alpha = 255 * entrada * (1.0f - vida * 0.72f);
    float tamano = tamanoBase * (0.55f + vida * 0.80f);
    p.imageMode(CENTER);
    p.tint(255, alpha);
    p.image(spritesExplosionFinal.get(frameExplosion), x, y, tamano, tamano);
    p.noTint();
  }

  void dibujarEmperadorEscena(PImage imagen, float centroX, float baseY, float alto, float alpha){
    if(imagen == null || alpha <= 0) return;
    float ancho = alto * imagen.width / (float)imagen.height;
    p.imageMode(CENTER);
    p.tint(255, constrain(alpha, 0, 255));
    p.image(imagen, centroX, baseY - alto * 0.5f, ancho, alto);
    p.noTint();
  }

  float smoothstep(float inicio, float fin, float valor){
    float t = constrain((valor - inicio) / (fin - inicio), 0, 1);
    return t * t * (3.0f - 2.0f * t);
  }

  PImage limpiarFondoAjedrez(PImage imagen){
    if(imagen == null) return null;
    imagen.format = ARGB;
    imagen.loadPixels();
    int total = imagen.pixels.length;
    boolean[] fondo = new boolean[total];
    int[] cola = new int[total];
    int inicio = 0;
    int fin = 0;

    for(int x = 0; x < imagen.width; x++){
      fin = encolarFondoClaro(imagen, x, fondo, cola, fin);
      fin = encolarFondoClaro(imagen, (imagen.height - 1) * imagen.width + x, fondo, cola, fin);
    }
    for(int y = 1; y < imagen.height - 1; y++){
      fin = encolarFondoClaro(imagen, y * imagen.width, fondo, cola, fin);
      fin = encolarFondoClaro(imagen, y * imagen.width + imagen.width - 1, fondo, cola, fin);
    }

    while(inicio < fin){
      int indice = cola[inicio++];
      int x = indice % imagen.width;
      int y = indice / imagen.width;
      if(x > 0) fin = encolarFondoClaro(imagen, indice - 1, fondo, cola, fin);
      if(x < imagen.width - 1) fin = encolarFondoClaro(imagen, indice + 1, fondo, cola, fin);
      if(y > 0) fin = encolarFondoClaro(imagen, indice - imagen.width, fondo, cola, fin);
      if(y < imagen.height - 1) fin = encolarFondoClaro(imagen, indice + imagen.width, fondo, cola, fin);
    }

    for(int i = 0; i < total; i++){
      if(fondo[i]) imagen.pixels[i] = p.color(0, 0);
    }
    imagen.updatePixels();
    return imagen;
  }

  int encolarFondoClaro(PImage imagen, int indice, boolean[] fondo, int[] cola, int fin){
    if(indice < 0 || indice >= imagen.pixels.length || fondo[indice]) return fin;
    int colorPixel = imagen.pixels[indice];
    float rojo = p.red(colorPixel);
    float verde = p.green(colorPixel);
    float azul = p.blue(colorPixel);
    float minimo = min(rojo, min(verde, azul));
    float maximo = max(rojo, max(verde, azul));
    if(minimo > 205 && maximo - minimo < 30){
      fondo[indice] = true;
      cola[fin++] = indice;
    }
    return fin;
  }
  
  void displayVictoria(){
    p.background(0);
    p.fill(255, 215, 0);
    p.textFont(fontIntroBold);
    p.textSize(60);
    p.textAlign(CENTER, CENTER);
    p.text("VICTORIA", p.width / 2.0, p.height / 2.0 - 70);
    p.textFont(fontIntroNormal);
    p.textSize(30);
    p.text("La Tierra ha sido salvada por " + nombrePiloto, p.width / 2.0, p.height / 2.0);
    p.text("Puntaje final: " + puntaje, p.width / 2.0, p.height / 2.0 + 45);
    displayBotonReiniciar();
  }
  
  void displayDerrota(){
    p.background(0);
    p.fill(255, 0, 0);
    p.textFont(fontIntroBold);
    p.textSize(60);
    p.textAlign(CENTER, CENTER);
    p.text("DERROTA", p.width / 2.0, p.height / 2.0 - 70);
    p.textFont(fontIntroNormal);
    p.textSize(30);
    p.text("La Tierra ha caido...", p.width / 2.0, p.height / 2.0);
    p.text("Piloto: " + nombrePiloto + " | Puntaje: " + puntaje, p.width / 2.0, p.height / 2.0 + 45);
    displayBotonReiniciar();
  }

  void displayBotonReiniciar(){
    float espacio = 18 * escalaMovilUI();
    float panelW = min(p.width * 0.78f, 760 * escalaMovilUI());
    float botonW = (panelW - espacio) * 0.5f;
    float botonH = constrain(p.height * 0.12f, 64, 112);
    float botonX = (p.width - panelW) * 0.5f;
    float botonY = p.height * 0.68f;

    p.pushStyle();
    dibujarBotonMenu("REINICIAR", botonX, botonY, botonW, botonH, false);
    dibujarBotonMenu("CERRAR APP", botonX + botonW + espacio, botonY, botonW, botonH, true);
    p.popStyle();
  }

  void dibujarBotonMenu(String texto, float x, float y, float w, float h, boolean peligro){
    int colorBorde = peligro ? p.color(255, 75, 65) : p.color(0, 210, 255);
    p.noStroke();
    p.fill(p.red(colorBorde), p.green(colorBorde), p.blue(colorBorde), 65);
    p.rect(x - 6, y - 6, w + 12, h + 12, 18);
    p.stroke(colorBorde);
    p.strokeWeight(max(2, escalaMovilUI() * 3));
    p.fill(peligro ? p.color(74, 16, 22, 245) : p.color(8, 35, 62, 245));
    p.rect(x, y, w, h, 14);
    p.fill(255);
    p.textFont(fontIntroBold);
    p.textSize(constrain(h * 0.30f, 17, 34));
    p.textAlign(CENTER, CENTER);
    p.text(texto, x + w * 0.5f, y + h * 0.5f);
  }

  void keyPressed(int keyCode, char key){
    if(estadoActual == ESTADO_REGISTRO){
      if(keyCode == ENTER || keyCode == RETURN){
        iniciarIntro();
      }else if(keyCode == BACKSPACE){
        if(nombreEnEdicion.length() > 0){
          nombreEnEdicion = nombreEnEdicion.substring(0, nombreEnEdicion.length() - 1);
        }
      }else if(keyCode != CODED && key >= 32 && key <= 126 && nombreEnEdicion.length() < 18){
        nombreEnEdicion += key;
      }
    }
    else if(estadoActual == ESTADO_INTRO){
      if(key == ' ' || keyCode == ENTER || keyCode == RETURN) iniciarNivel();
    }
    else if(estadoActual == ESTADO_JUGANDO){
      if(key=='p' || key=='P'){
        cambiarPausa();
        return;
      }
      if(pausado) return;
      player.keyPressed(keyCode);
      
      if(key=='e' || key=='E'){
        dispararMisil();
      }
      else if(key=='w' || key=='W'){
        dispararRafaga();
      }
      else if(key=='q' || key=='Q'){
        dispararLaser();
      }
    }
    else if(estaFinalizado()){
      if(keyCode == ENTER || keyCode == RETURN || key == ' '){
        reiniciarPartida();
      }
    }
  }

  void keyReleased(int keyCode){
    if(estadoActual == ESTADO_JUGANDO){
      player.keyReleased(keyCode);
    }
  }

  void dibujarFondoBase(){
    p.imageMode(CORNER);
    PImage fondo = null;
    if(estadoActual == ESTADO_INTRO || estadoActual == ESTADO_REGISTRO){
      fondo = imagenIntro;
    }else if(nivelActual >= 1 && nivelActual <= 5){
      fondo = fondosNivel[nivelActual];
    }

    if(fondo != null){
      p.image(fondo, 0, 0, p.width, p.height);
    }else{
      p.background(0);
    }
  }

  void dibujarFondoSalto(){
    p.imageMode(CORNER);
    PImage fondo = null;
    if(nivelActual >= 1 && nivelActual <= 4){
      fondo = fondosSalto[nivelActual];
    }

    if(fondo != null){
      p.image(fondo, 0, 0, p.width, p.height);
    }else{
      dibujarFondoBase();
    }
  }

  ArrayList<PImage> cargarSpritesExplosion(){
    ArrayList<PImage> sprites = new ArrayList<PImage>();
    String[] archivos = {"explosion_1.png", "explosion_2.png", "explosion_3.png"};
    for(String archivo : archivos){
      PImage img = p.loadImage(archivo);
      if(img != null){
        int tamano = int(80 * escalaJuego());
        img.resize(tamano, tamano);
        sprites.add(img);
      }
    }
    return sprites;
  }

  ArrayList<PImage> cargarSpritesExplosionFinal(){
    ArrayList<PImage> sprites = new ArrayList<PImage>();
    String[] archivos = {"explosion_1.png", "explosion_2.png", "explosion_3.png"};
    for(String archivo : archivos){
      PImage img = p.loadImage(archivo);
      if(img != null) sprites.add(img);
    }
    return sprites;
  }

  void agregarExplosion(float x, float y){
    if(explosions.size() >= maxExplosiones){
      explosions.remove(0);
    }
    explosions.add(new Explosion(p, x, y, spritesExplosion));
  }

  void dibujarRutaGalaxia(float progreso){
    float centroY = p.height * 0.49;
    float tamanoPunto = constrain(p.height * 0.13f, 72, 118);
    float centroOrigenX = p.width * 0.16f;
    float centroDestinoX = p.width * 0.84f;
    float inicioX = centroOrigenX + tamanoPunto * 0.62f;
    float finX = centroDestinoX - tamanoPunto * 0.62f;

    dibujarPuntoNebulosa(imagenNebulosaOrigen, centroOrigenX, centroY,
      tamanoPunto, p.color(70, 210, 255), nombresGalaxia[nivelActual]);
    dibujarPuntoNebulosa(imagenNebulosaDestino, centroDestinoX, centroY,
      tamanoPunto, p.color(255, 150, 65), nombresGalaxia[siguienteNivel]);

    p.stroke(90, 210, 255, 170);
    p.strokeWeight(3);
    p.line(inicioX, centroY, finX, centroY);

    float naveX = lerp(inicioX, finX, progreso);
    if(imagenCazaIndicador != null){
      p.pushStyle();
      float oscilacion = sin(tiempoEspera * 5.0f) * 2.5f;
      dibujarCazaSalto(naveX + 10, centroY + oscilacion, 52, 255);
      dibujarCazaSalto(naveX - 27, centroY - 25 - oscilacion, 40, 220);
      dibujarCazaSalto(naveX - 27, centroY + 25 - oscilacion, 40, 220);
      p.popStyle();
    }else{
      p.fill(0, 220, 255);
      p.triangle(naveX + 22, centroY, naveX - 18, centroY - 14, naveX - 18, centroY + 14);
      p.fill(255, 120, 40, 180);
      p.triangle(naveX - 18, centroY, naveX - 38, centroY - 8, naveX - 38, centroY + 8);
    }
  }

  void dibujarPuntoNebulosa(PImage imagen, float centroX, float centroY,
    float tamano, int colorBorde, String etiqueta){
    float ancho = tamano * 1.22f;
    float alto = tamano;
    p.pushStyle();
    p.noStroke();
    p.fill(colorBorde, 48);
    p.rectMode(CENTER);
    p.rect(centroX, centroY, ancho + 16, alto + 16, 18);
    p.clip(centroX - ancho * 0.5f, centroY - alto * 0.5f, ancho, alto);
    p.imageMode(CENTER);
    if(imagen != null) p.image(imagen, centroX, centroY, ancho, alto);
    else{
      p.fill(12, 18, 42);
      p.rect(centroX, centroY, ancho, alto);
    }
    p.noClip();
    p.noFill();
    p.stroke(colorBorde);
    p.strokeWeight(3);
    p.rectMode(CENTER);
    p.rect(centroX, centroY, ancho, alto, 12);
    p.noStroke();
    p.fill(255);
    p.textFont(fontIntroBold);
    p.textSize(constrain(p.height * 0.020f, 12, 20));
    p.textAlign(CENTER, TOP);
    p.text(etiqueta, centroX, centroY + alto * 0.5f + 10);
    p.popStyle();
  }

  void dibujarCazaSalto(float x, float y, float tamano, float alpha){
    p.pushMatrix();
    p.tint(120, 220, 255, alpha);
    p.imageMode(CENTER);
    p.translate(x, y);
    p.rotate(HALF_PI);
    p.image(imagenCazaIndicador, 0, 0, tamano, tamano);
    p.popMatrix();
    p.noTint();
    p.noStroke();
    p.fill(255, 130, 40, alpha * 0.82f);
    p.triangle(x - tamano * 0.42f, y,
      x - tamano * 0.76f, y - tamano * 0.12f,
      x - tamano * 0.76f, y + tamano * 0.12f);
  }

  void dibujarBarraIntegridad(float x, float y, float w, float h){
    float integridad = constrain(player.vidas / float(vidasNivel[nivelActual-1]), 0, 1);
    p.noStroke();
    p.fill(70, 20, 20);
    p.rect(x, y, w, h, 4);
    if(integridad > 0.66){
      p.fill(0, 220, 110);
    }else if(integridad > 0.33){
      p.fill(255, 200, 0);
    }else{
      p.fill(255, 70, 40);
    }
    p.rect(x, y, w * integridad, h, 4);
  }

  String estadoCaza(){
    float integridad = player.vidas / float(vidasNivel[nivelActual-1]);
    if(integridad > 0.66) return "Operativo";
    if(integridad > 0.33) return "Da\u00f1ado";
    return "Critico";
  }

  String estadoApoyos(){
    String estado = "";
    for(int i = 0; i < apoyos.size(); i++){
      SupportFighter apoyo = apoyos.get(i);
      if(i > 0) estado += " | ";
      estado += apoyo.activo ? apoyo.vidas + "/10" : "fuera";
    }
    return estado;
  }

  int puntosPorEnemigo(Enemy e){
    if(e instanceof EnemyNodriza) return 500;
    if(e instanceof EnemyCruceroEmperador) return 2500;
    return 100 + nivelActual * 25;
  }

  void registrarDestruccionNivel5(Enemy destruido){
    if(nivelActual != 5 || cruceroNivel5 == null) return;

    if(destruido instanceof EnemyNaveRoja){
      ovnisDestruidosNivel5++;
      int mitad = ceil(ovnisInicialesNivel5 * 0.5f);
      if(!ataqueUnoCruceroActivado && ovnisDestruidosNivel5 >= mitad){
        ataqueUnoCruceroActivado = true;
        cruceroNivel5.dispararAtaqueUno(player);
        agregarAvisoFase("ALERTA: primer ataque del crucero.");
      }
      if(ovnisDestruidosNivel5 >= ovnisInicialesNivel5){
        activarNodrizasNivel5();
      }
    }else if(destruido instanceof EnemyNodriza){
      nodrizasDestruidasNivel5++;
      if(!ataqueDosCruceroActivado && nodrizasDestruidasNivel5 >= 1){
        ataqueDosCruceroActivado = true;
        cruceroNivel5.activarAtaquesIntensificados(player);
        agregarAvisoFase("Una nodriza ha caido.\nEl crucero intensifica sus ataques.");
      }
      if(nodrizasDestruidasNivel5 >= 2){
        activarCruceroFinalNivel5();
      }
    }
  }

  void activarNodrizasNivel5(){
    faseNivel5 = FASE_5_NODRIZAS;
    for(Enemy e : enemies){
      if(e instanceof EnemyNodriza){
        e.activoEnCombate = true;
        e.invulnerable = false;
        e.contadorDisparo = 0;
      }
    }
    agregarAvisoFase("OVNIs eliminados.\nLas nodrizas entran en combate.");
  }

  void activarCruceroFinalNivel5(){
    faseNivel5 = FASE_5_CRUCERO;
    cruceroNivel5.activarFaseFinal();
    agregarAvisoFase("Blindaje destruido.\nEl crucero ya recibe dano.");
  }

  void agregarAvisoFase(String texto){
    if(events.size() < 3){
      events.add(new EventMessage(p, imagenComandante, texto, 2.0f));
    }
    sound.evento();
  }

  void procesarDisparosTactiles(){
    if(!modoMovil || estadoActual != ESTADO_JUGANDO) return;

    if(cooldownRafagaTouch > 0) cooldownRafagaTouch--;
    if(cooldownMisilTouch > 0) cooldownMisilTouch--;
    if(cooldownLaserTouch > 0) cooldownLaserTouch--;

    // Cada pulsacion nueva responde en este mismo fotograma, aunque el
    // temporizador del arma conserve tiempo de una pulsacion anterior.
    if(controlesTactiles.rafagaActiva && !rafagaTouchAnterior) cooldownRafagaTouch = 0;
    if(controlesTactiles.misilActivo && !misilTouchAnterior) cooldownMisilTouch = 0;
    if(controlesTactiles.laserActivo && !laserTouchAnterior) cooldownLaserTouch = 0;

    // Gatillos continuos: movimiento y disparo se procesan en el mismo frame.
    if(controlesTactiles.rafagaActiva && cooldownRafagaTouch <= 0){
      dispararRafaga();
      cooldownRafagaTouch = CADENCIA_RAFAGA_TOUCH;
    }
    if(controlesTactiles.misilActivo && cooldownMisilTouch <= 0){
      dispararMisil();
      cooldownMisilTouch = CADENCIA_MISIL_TOUCH;
    }
    if(controlesTactiles.laserActivo && cooldownLaserTouch <= 0){
      dispararLaser();
      cooldownLaserTouch = CADENCIA_LASER_TOUCH;
    }

    rafagaTouchAnterior = controlesTactiles.rafagaActiva;
    misilTouchAnterior = controlesTactiles.misilActivo;
    laserTouchAnterior = controlesTactiles.laserActivo;
  }

  void dispararMisil(){
    if(bullets.size() < maxBalasJugador){
      bullets.add(new Bullet(p, player.x, player.y, Bullet.TIPO_MISIL, sound));
    }
  }

  void dispararRafaga(){
    if(bullets.size() < maxBalasJugador - 1){
      float separacion = 20 * escalaJuego();
      bullets.add(new Bullet(p, player.x-separacion, player.y, Bullet.TIPO_METRALLETA, sound));
      bullets.add(new Bullet(p, player.x+separacion, player.y, Bullet.TIPO_METRALLETA, sound, false, false));
    }
  }

  void dispararLaser(){
    if(bullets.size() < maxBalasJugador){
      bullets.add(new Bullet(p, player.x, player.y, Bullet.TIPO_LASER, sound));
    }
  }

  void displayRegistroMovil(){
    dibujarFondoBase();
    p.pushStyle();
    p.fill(0, 185);
    p.rect(0, 0, p.width, p.height);

    float escala = escalaMovilUI();
    float cajaW = min(p.width * 0.72f, 760 * escala);
    float cajaH = constrain(p.height * 0.12f, 58, 110);
    float cajaX = (p.width - cajaW) / 2.0f;
    float cajaY = p.height * 0.40f;

    p.textAlign(CENTER, CENTER);
    p.textFont(fontIntroBold);
    p.textSize(constrain(p.height * 0.068f, 28, 64));
    p.fill(255, 215, 0);
    p.text("REGISTRO DE PILOTO", p.width / 2.0f, p.height * 0.22f);

    p.textFont(fontIntroNormal);
    p.textSize(constrain(p.height * 0.032f, 16, 30));
    p.fill(220);
    p.text("Toca el campo, escribe tu nombre y presiona ENTER", p.width / 2.0f, p.height * 0.31f);

    p.noStroke();
    p.fill(8, 18, 40, 235);
    p.rect(cajaX, cajaY, cajaW, cajaH, 12);
    p.stroke(0, 210, 255);
    p.strokeWeight(max(2, 2 * escala));
    p.noFill();
    p.rect(cajaX, cajaY, cajaW, cajaH, 12);

    String cursor = (frameCount / 30) % 2 == 0 ? "_" : "";
    String textoNombre = nombreEnEdicion.length() == 0 ? "Nombre del piloto" : nombreEnEdicion + cursor;
    p.textFont(fontIntroBold);
    p.textSize(constrain(cajaH * 0.42f, 22, 44));
    p.fill(nombreEnEdicion.length() == 0 ? p.color(135) : p.color(255));
    p.text(textoNombre, p.width / 2.0f, cajaY + cajaH / 2.0f);

    p.textFont(fontIntroNormal);
    p.textSize(constrain(p.height * 0.026f, 14, 25));
    p.fill(180, 230, 255);
    p.text("Bonus de inicio: +" + bonusInicio + " puntos", p.width / 2.0f, cajaY + cajaH + p.height * 0.09f);
    p.popStyle();
  }

  void displayIntroMovil(){
    dibujarFondoBase();
    p.pushStyle();
    p.fill(0, 125);
    p.rect(0, 0, p.width, p.height);
    p.textAlign(CENTER, CENTER);
    p.textFont(fontIntroBold);
    p.textSize(constrain(p.height * 0.047f, 22, 48));
    p.textLeading(constrain(p.height * 0.073f, 31, 66));
    p.fill(255, 215, 0);

    String texto =
      "A\u00d1O 2147\n\n" +
      "La raza Xhar'Kor ha iniciado la invasion de la Tierra.\n" +
      "Miles de naves avanzan hacia nuestro planeta.\n\n" +
      "La ultima esperanza de la humanidad es " + nombrePiloto + ".\n" +
      "Comandante Thiakor Gomez: despegue inmediato.\n\n" +
      "TOCA LA PANTALLA PARA COMENZAR";

    p.text(texto, p.width * 0.10f, p.height * 0.08f, p.width * 0.80f, p.height * 0.84f);
    p.popStyle();
  }

  void displayHUDMovil(){
    p.pushStyle();
    float escala = escalaMovilUI();
    float margen = max(12, min(p.width, p.height) * 0.022f);
    float fuente = constrain(p.height * 0.026f, 14, 25);
    float altoLinea = fuente * 1.38f;
    float panelH = altoLinea * 3.35f;
    float panelW = min(p.width * 0.43f, 570 * escala);

    p.noStroke();
    p.fill(0, 175);
    p.rect(margen, margen, panelW, panelH, 10);
    p.rect(p.width - margen - panelW, margen, panelW, panelH, 10);

    p.textFont(fontIntroNormal);
    p.textSize(fuente);
    p.fill(255);
    p.textAlign(LEFT, TOP);
    p.text("Piloto: " + nombrePiloto, margen * 1.8f, margen * 1.55f);
    p.text("Puntaje: " + puntaje, margen * 1.8f, margen * 1.55f + altoLinea);
    p.text("Sector: " + nivelActual + "/5 - " + nombresGalaxia[nivelActual],
      margen * 1.8f, margen * 1.55f + altoLinea * 2);

    float derechaX = p.width - margen * 1.8f;
    p.textAlign(RIGHT, TOP);
    p.text("Integridad: " + player.vidas + "/" + vidasNivel[nivelActual-1],
      derechaX, margen * 1.55f);
    p.text("Enemigos: " + enemigosDerrotados + "/" + totalEnemigosNivel,
      derechaX, margen * 1.55f + altoLinea);
    p.text("Apoyos: " + estadoApoyos(),
      derechaX, margen * 1.55f + altoLinea * 2);
    p.popStyle();
  }
}
