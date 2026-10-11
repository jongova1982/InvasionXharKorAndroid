class EventMessage{
  static final float DURACION_MAXIMA_NUBE = 2.0f;
  static final float ESCALA_NUBE = 0.50f;
  PApplet p;
  PImage imagen;
  String texto;
  float tiempoTotal;
  float tiempoTranscurrido = 0;
  PFont fuenteNegrita;
  
  // Para eventos con dos personajes
  boolean mostrarOtroPersonaje = false;
  PImage imagenOtro;
  String textoOtro;
  
  EventMessage(PApplet p, PImage imagen, String texto, float duracion){
    this.p = p;
    this.imagen = imagen;
    this.texto = texto;
    this.tiempoTotal = min(duracion, DURACION_MAXIMA_NUBE);
    this.fuenteNegrita = p.createFont("SansSerif Bold", 16, true);
  }
  
  void update(){
    tiempoTranscurrido += 1.0/60.0;
  }
  
  boolean terminada(){
    return tiempoTranscurrido >= tiempoTotal;
  }
  
  void display(){
    float escala = constrain(min(p.width / 1000.0f, p.height / 700.0f), 0.72f, 1.85f);
    if(!mostrarOtroPersonaje){
      // UN SOLO PERSONAJE (Comandante)
      float xImagen = 78 * escala;
      float yImagen = p.height * 0.30f;
      
      if(imagen != null){
        p.imageMode(CENTER);
        p.image(imagen, xImagen, yImagen, 95 * escala, 95 * escala);
      }
      
      float xTexto = xImagen + 62 * escala;
      float yTexto = yImagen - 45 * escala;
      float anchoTexto = min(330 * escala, p.width * 0.34f) * ESCALA_NUBE;
      float altoTexto = 88 * escala * ESCALA_NUBE;
      
      dibujarNubeDialogo(xTexto, yTexto, anchoTexto, altoTexto, xImagen + 35 * escala, yImagen - 25 * escala, texto, p.color(0));
      
    }else{
      // DOS PERSONAJES (Comandante y Emperador)
      float xComandante = 78 * escala;
      float xEmperador = p.width - 78 * escala;
      float yBase = p.height * 0.30f;
      
      if(imagen != null){
        p.imageMode(CENTER);
        p.image(imagen, xComandante, yBase, 85 * escala, 85 * escala);
      }
      
      if(imagenOtro != null){
        p.imageMode(CENTER);
        p.image(imagenOtro, xEmperador, yBase, 85 * escala, 85 * escala);
      }
      
      float margen = 18 * escala;
      float anchoNube = min(260 * escala, (p.width - 220 * escala) / 2.0f) * ESCALA_NUBE;
      float altoNube = 82 * escala * ESCALA_NUBE;
      float yNube = yBase - 48 * escala;
      
      dibujarNubeDialogo(xComandante + 55 * escala, yNube, anchoNube, altoNube, xComandante + 25 * escala, yBase - 18 * escala, texto, p.color(0));
      dibujarNubeDialogo(p.width - margen - anchoNube - 55 * escala, yNube, anchoNube, altoNube, xEmperador - 25 * escala, yBase - 18 * escala, textoOtro != null ? textoOtro : "", p.color(0));
    }
  }
  
  void dibujarNubeDialogo(float x, float y, float w, float h, float colaX, float colaY, String mensaje, int colorTexto){
    p.pushStyle();
    
    p.fill(255);
    p.stroke(0);
    p.strokeWeight(max(1, 2 * ESCALA_NUBE));
    
    float centroX = x + w / 2.0;
    float centroY = y + h / 2.0;
    p.triangle(
      centroX - 12 * ESCALA_NUBE, y + h - 6 * ESCALA_NUBE,
      centroX + 12 * ESCALA_NUBE, y + h - 6 * ESCALA_NUBE,
      colaX, colaY
    );
    p.rect(
      x + 10 * ESCALA_NUBE, y + 10 * ESCALA_NUBE,
      w - 20 * ESCALA_NUBE, h - 20 * ESCALA_NUBE,
      24 * ESCALA_NUBE
    );
    
    float r = 26 * ESCALA_NUBE;
    p.ellipse(x + 22 * ESCALA_NUBE, y + 22 * ESCALA_NUBE, r, r);
    p.ellipse(x + w * 0.28f, y + 10 * ESCALA_NUBE, r + 8 * ESCALA_NUBE, r);
    p.ellipse(x + w * 0.55f, y + 8 * ESCALA_NUBE, r + 12 * ESCALA_NUBE, r + 4 * ESCALA_NUBE);
    p.ellipse(x + w - 24 * ESCALA_NUBE, y + 22 * ESCALA_NUBE, r, r);
    p.ellipse(x + w - 16 * ESCALA_NUBE, y + h * 0.55f, r, r + 8 * ESCALA_NUBE);
    p.ellipse(x + w * 0.72f, y + h - 9 * ESCALA_NUBE, r + 8 * ESCALA_NUBE, r);
    p.ellipse(x + w * 0.42f, y + h - 8 * ESCALA_NUBE, r + 6 * ESCALA_NUBE, r);
    p.ellipse(x + 20 * ESCALA_NUBE, y + h * 0.62f, r, r + 6 * ESCALA_NUBE);
    
    p.noStroke();
    p.fill(255);
    p.rect(
      x + 14 * ESCALA_NUBE, y + 14 * ESCALA_NUBE,
      w - 28 * ESCALA_NUBE, h - 28 * ESCALA_NUBE,
      20 * ESCALA_NUBE
    );
    
    p.fill(colorTexto);
    p.textFont(fuenteNegrita);
    p.textSize(constrain(min(p.width, p.height) * 0.023f * ESCALA_NUBE, 8, 13));
    p.textAlign(CENTER, CENTER);
    p.textLeading(18 * ESCALA_NUBE);
    p.text(
      mensaje,
      x + 12 * ESCALA_NUBE, y + 8 * ESCALA_NUBE,
      w - 24 * ESCALA_NUBE, h - 16 * ESCALA_NUBE
    );
    
    p.popStyle();
  }
}

