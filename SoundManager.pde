import android.media.AudioAttributes;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.content.res.AssetFileDescriptor;

/**
 * Audio ligero para Android.
 *
 * SoundPool permite reproducir disparos superpuestos sin bloquear el render.
 * Si un archivo no carga, el juego continua silenciosamente.
 */
class SoundManager{
  PApplet p;
  SoundPool soundPool;
  HashMap<String, PImage> cacheImagenes = new HashMap<String, PImage>();

  int soIntro;
  int soMovimientoCaza;
  int soDisparoMisil;
  int soDisparoMetralleta;
  int soDisparoLaser;
  int soDisparoNodriza;
  int soMovimientoNodriza;
  int soExplosion;
  int soMovimientoOvni;
  int soDisparoOvni;
  int soMovimientoCrucero;
  int soLaserCrucero;
  int soGritoCaida;
  MediaPlayer musicaCaidaEmperador;
  MediaPlayer musicaVictoria;
  MediaPlayer audioVictoriaEmperador;

  int ultimoMovimientoCaza = -999;
  int ultimoDisparoMisil = -999;
  int ultimoDisparoMetralleta = -999;
  int ultimoDisparoLaser = -999;
  int ultimoDisparoNodriza = -999;
  int ultimoExplosion = -999;
  int ultimoMovimientoNodriza = -999;
  int ultimoMovimientoOvni = -999;
  int ultimoDisparoOvni = -999;
  int ultimoMovimientoCrucero = -999;
  int ultimoLaserCrucero = -999;
  int streamSaltoCazas = 0;
  boolean audioSaltoCazasActivo = false;

  SoundManager(PApplet p){
    this.p = p;
    AudioAttributes atributos = new AudioAttributes.Builder()
      .setUsage(AudioAttributes.USAGE_GAME)
      .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
      .build();

    soundPool = new SoundPool.Builder()
      .setMaxStreams(12)
      .setAudioAttributes(atributos)
      .build();

    cargarSonidos();
  }

  void cargarSonidos(){
    soIntro = cargar("sonido_intro.wav");
    soMovimientoCaza = cargar("sonidocaza.wav");
    soDisparoMisil = cargar("sonido_misil.wav");
    soDisparoMetralleta = cargar("sonido_metralleta.wav");
    soDisparoLaser = cargar("dipsparocaza_laser.wav");
    soDisparoNodriza = cargar("disparo_nodriza.wav");
    soMovimientoNodriza = cargar("sonidonodriza.wav");
    soExplosion = cargar("explosion.wav");
    soMovimientoOvni = cargar("sonidovni.wav");
    soDisparoOvni = cargar("disparovni.wav");
    soMovimientoCrucero = cargar("sonido_navecrucero.mp3");
    soLaserCrucero = cargar("laser_crucero.mp3");
    soGritoCaida = cargar("grito_caida.mp3");
    musicaCaidaEmperador = cargarMusica("sonido_caida_emperador.mp3");
    musicaVictoria = cargarMusica("victoria_1.mp3");
    audioVictoriaEmperador = cargarMusica("audio_vicoria-emperador.mp3");
  }

  MediaPlayer cargarMusica(String archivo){
    try{
      AssetFileDescriptor descriptor = p.getContext().getAssets().openFd(archivo);
      MediaPlayer reproductor = new MediaPlayer();
      reproductor.setDataSource(descriptor.getFileDescriptor(), descriptor.getStartOffset(), descriptor.getLength());
      descriptor.close();
      reproductor.setLooping(true);
      reproductor.setVolume(0.72f, 0.72f);
      reproductor.prepare();
      return reproductor;
    }catch(Exception error){
      println("Musica Android no disponible: " + archivo);
      return null;
    }
  }

  int cargar(String archivo){
    try{
      AssetFileDescriptor descriptor = p.getContext().getAssets().openFd(archivo);
      int idSonido = soundPool.load(descriptor, 1);
      descriptor.close();
      return idSonido;
    }catch(Exception error){
      println("Audio Android no disponible: " + archivo);
      return 0;
    }
  }

  PImage imagen(String archivo, int ancho, int alto){
    String clave = archivo + "#" + ancho + "x" + alto;
    PImage guardada = cacheImagenes.get(clave);
    if(guardada != null) return guardada;

    PImage cargada = p.loadImage(archivo);
    if(cargada != null && ancho > 0 && alto > 0){
      cargada.resize(ancho, alto);
      cacheImagenes.put(clave, cargada);
    }
    return cargada;
  }

  void reproducir(int sonido){
    if(sonido > 0){
      soundPool.play(sonido, 0.78f, 0.78f, 1, 0, 1.0f);
    }
  }

  int reproducirConEspera(int sonido, int ultimoFrame, int esperaFrames){
    if(p.frameCount - ultimoFrame < esperaFrames) return ultimoFrame;
    reproducir(sonido);
    return p.frameCount;
  }

  void introduccion(){ reproducir(soIntro); }
  void movimientoCaza(){ ultimoMovimientoCaza = reproducirConEspera(soMovimientoCaza, ultimoMovimientoCaza, 18); }
  void iniciarAudioSaltoGalactico(){
    if(audioSaltoCazasActivo || soMovimientoCaza <= 0) return;
    streamSaltoCazas = soundPool.play(soMovimientoCaza, 0.82f, 0.82f, 2, -1, 1.0f);
    audioSaltoCazasActivo = streamSaltoCazas > 0;
  }
  void detenerAudioSaltoGalactico(){
    if(streamSaltoCazas > 0){
      soundPool.stop(streamSaltoCazas);
    }
    streamSaltoCazas = 0;
    audioSaltoCazasActivo = false;
  }
  void disparoMisil(){ ultimoDisparoMisil = reproducirConEspera(soDisparoMisil, ultimoDisparoMisil, 4); }
  void disparoMetralleta(){ ultimoDisparoMetralleta = reproducirConEspera(soDisparoMetralleta, ultimoDisparoMetralleta, 6); }
  void disparoLaser(){ ultimoDisparoLaser = reproducirConEspera(soDisparoLaser, ultimoDisparoLaser, 2); }
  void disparoNodriza(){ ultimoDisparoNodriza = reproducirConEspera(soDisparoNodriza, ultimoDisparoNodriza, 16); }
  void movimientoNodriza(){ ultimoMovimientoNodriza = reproducirConEspera(soMovimientoNodriza, ultimoMovimientoNodriza, 60); }
  void explosion(){ ultimoExplosion = reproducirConEspera(soExplosion, ultimoExplosion, 6); }
  void evento(){ ultimoExplosion = reproducirConEspera(soExplosion, ultimoExplosion, 12); }
  void movimientoOvni(){ ultimoMovimientoOvni = reproducirConEspera(soMovimientoOvni, ultimoMovimientoOvni, 60); }
  void disparoOvni(){ ultimoDisparoOvni = reproducirConEspera(soDisparoOvni, ultimoDisparoOvni, 14); }
  void movimientoCrucero(){ ultimoMovimientoCrucero = reproducirConEspera(soMovimientoCrucero, ultimoMovimientoCrucero, 300); }
  void laserCrucero(){ ultimoLaserCrucero = reproducirConEspera(soLaserCrucero, ultimoLaserCrucero, 900); }
  void iniciarSonidosInvasion(){
    reproducir(soMovimientoCrucero);
    reproducir(soMovimientoNodriza);
    reproducir(soMovimientoOvni);
  }
  void ataqueSonoroInvasion(int pulso){
    if(pulso % 3 == 0) reproducir(soLaserCrucero);
    else if(pulso % 2 == 0) reproducir(soDisparoNodriza);
    else reproducir(soDisparoOvni);
    if(pulso % 4 == 0) reproducir(soExplosion);
  }
  void iniciarCaidaEmperador(){
    reproducir(soGritoCaida);
    if(musicaCaidaEmperador != null){
      try{
        musicaCaidaEmperador.seekTo(0);
        musicaCaidaEmperador.start();
      }catch(Exception error){
        println("No se pudo iniciar sonido_caida_emperador.mp3");
      }
    }
  }
  void detenerCaidaEmperador(){
    if(musicaCaidaEmperador != null){
      try{
        musicaCaidaEmperador.pause();
        musicaCaidaEmperador.seekTo(0);
      }catch(Exception error){
        println("No se pudo detener sonido_caida_emperador.mp3");
      }
    }
  }
  void iniciarMusicaVictoria(){
    if(musicaVictoria != null){
      try{
        musicaVictoria.seekTo(0);
        musicaVictoria.start();
      }catch(Exception error){
        println("No se pudo iniciar victoria_1.mp3");
      }
    }
  }
  void detenerMusicaVictoria(){
    if(musicaVictoria != null){
      try{
        musicaVictoria.pause();
        musicaVictoria.seekTo(0);
      }catch(Exception error){
        println("No se pudo detener victoria_1.mp3");
      }
    }
  }
  void iniciarAudioVictoriaEmperador(){
    if(audioVictoriaEmperador != null){
      try{
        audioVictoriaEmperador.seekTo(0);
        audioVictoriaEmperador.start();
      }catch(Exception error){
        println("No se pudo iniciar audio_vicoria-emperador.mp3");
      }
    }
  }
  void detenerAudioVictoriaEmperador(){
    if(audioVictoriaEmperador != null){
      try{
        audioVictoriaEmperador.pause();
        audioVictoriaEmperador.seekTo(0);
      }catch(Exception error){
        println("No se pudo detener audio_vicoria-emperador.mp3");
      }
    }
  }
}
