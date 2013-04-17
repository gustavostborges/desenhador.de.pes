import processing.serial.*;

int NEWLINE = 10;
Serial port;
float valorPiezoE;
float valorPiezoD;
float x, y, vx, vy, ang, vang;
float v;

ArrayList ler = new ArrayList();
float distanciaaler = random(80, 200);

float dis;

int timer;

void setup() {
  size(screen.width, screen.height);
  noCursor();
  background(255);
  stroke(0, 50);
  smooth();


  // v= velocidade do piezoD acelera desenho

  //vx = random(5,15);
  v = random(5, 15);

  x = width/2;

  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);

  timer  = millis();
}


void draw() {

  //println(port.available());
  if ( port.available() > 0) {
    lePorta(port);
  }

  desenha(x, y);

  ang = ang + vang;
  vang = vang * 0.98;

  x = x + v*sin(ang);
  y = y + v*cos(ang);

  v = v * 0.995;

  if ( x > width ) {
    x = 0; 
    //yant = y = random(height);
  }
  if ( x < 0 ) {
    x = width; 
    //yant = y = random(height);
  }
  if ( y > height ) {
    y = 0; 
    //xant =x = random(width);
  }
  if ( y < 0 ) {
    y = height; 
    //xant =x = random(width);
  }

  if (millis() - timer > 300000) {
    background(255);
    timer = millis();

    v = random(5, 15);
    x = width/2;
  }
}

void lePorta(Serial p) { 
  String valorString = p.readStringUntil(NEWLINE);

  println(valorString);

  if (valorString == null) return;

  char qualSensor = valorString.charAt(0);

  if (valorString != null && qualSensor == 'E') {
    valorPiezoE = parseFloat(valorString.substring(1));
    vang = valorPiezoE/20.0;
    println("esquerda: " + valorPiezoE);
  }
  else if (valorString != null && qualSensor == 'D') {
    valorPiezoD = parseFloat(valorString.substring(1));
    //proxTam = 10*valorPiezoE; 
    //pos = 10*valorPiezoE;
    // proxOpacidade = valorPiezoD*5;
    v = v + valorPiezoD/3.0;
    println("direita: " + valorPiezoD);
    println("v: " + v);
    // intensidadeD = valorPiezoD*2;
  }

  if (valorPiezoD + valorPiezoE > 5) {
    distanciaaler = random(80, 200);
  }
}


void desenha(float px, float py) {

  PVector d = new PVector(px, py, 0);
  ler.add(0, d);

  if (ler.size() > 500) {
    ler.clear();
  }

  for (int p=0; p<ler.size(); p++) {
    PVector v = (PVector) ler.get(p);
    float joinchance = p/ler.size() + d.dist(v)/distanciaaler;
    if (joinchance < random(0.4))  line(d.x, d.y, v.x, v.y);
  }
}

void mouseDragged() {
  desenha(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' ') {
    background(255);
    ler.clear();
  }
}



