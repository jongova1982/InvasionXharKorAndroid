class Explosion{
  PApplet p;
  float x, y;
  ArrayList<PImage> sprites;
  int frameActual = 0;
  int velocidadAnimacion = 3;
  int frameActualContador = 0;
  
  Explosion(PApplet p, float x, float y, ArrayList<PImage> sprites){
    this.p = p;
    this.x = x;
    this.y = y;
    this.sprites = sprites;
  }
  
  void update(){
    frameActualContador++;
    if(frameActualContador >= velocidadAnimacion){
      frameActual++;
      frameActualContador = 0;
    }
  }
  
  boolean terminada(){
    return sprites == null || sprites.size() == 0 || frameActual >= sprites.size();
  }
  
  void display(){
    if(sprites != null && frameActual < sprites.size()){
      PImage img = sprites.get(frameActual);
      p.imageMode(CENTER);
      p.image(img, x, y);
    }
  }
}
