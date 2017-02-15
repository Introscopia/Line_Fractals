/*
Line fractal Drawing sketch for r/Processing PWC.49
LEFT CLICK to draw lines.
RIGHT CLICK to drag vertices. dragging the root line doesn't do anything. sorry.
MOUSE WHEEL to alter fractal level.
BACKSPACE to delete last line.
ESC to cancel line drawing.
P or p to save screenshot.
*/
PVector p;
ArrayList<E> e;
float lerp;
line_segment ref;
boolean first, making, click = true, drag;
IntList address;
int lvl = 12;
int dragging;

void setup(){
  size(800, 600);//fullScreen();
  surface.setResizable(true);
  e = new ArrayList();
  first = true;
  strokeWeight(2);
  fill(0);
}

void draw(){
  background(255);
  for(int i = 0; i < e.size(); i++){
    e.get(i).display();
  }
  
  fractalize();
  
  PVector M = new PVector( mouseX, mouseY ); 
  
  if( e.size() > 0 && !making){
    FloatList dists = new FloatList();  
    for(int i = 0; i < e.size(); i++){
      dists.append( e.get(i).ls().dist( M ) );    
    }
    float min = dists.min();
    int I = 0;
    for(int i = 0; i < dists.size(); i++){
      if( dists.get(i) == min ){
        I = i;
        break;
      }
    }
    PVector c = e.get(I).ls().projection( M );
    ellipse( c.x, c.y, 4, 4 );
  }
  
  if( making ){
    line( p.x, p.y, mouseX, mouseY ); 
  }
}

void fractalize(){
  if( e.size() > 1 ){
    for(int i = 1; i < e.size(); i++){
      branch[] fracs = new branch[ lvl ];
      fracs[0] = e.get(i).sub_branch();
      for(int j = 1; j < lvl; j++){
        fracs[j] = fracs[j-1].sub_branch();
      }
      for(int j = 0; j < lvl; j++) fracs[j].display();
    } 
  }
}

class E{
  PVector i, f;
  line_segment linseg;
  E(){ linseg = new line_segment(); }
  boolean root(){ return true; }
  void display(){}
  void set_i( PVector v ){}
  void set_f( PVector v ){}
  line_segment ls(){return null;}
  line_segment assemble(){return null;}
  branch sub_branch(){ return null; }
}

class root extends E{
  root( PVector i, PVector f ){
    linseg = new line_segment( i, f );
    this.i = i;
    this.f = f;
  }
  void set_i( PVector v ){
    i = v.get();
    linseg = new line_segment( i, f );
  }
  void set_f( PVector v ){
    f = v.get();
    linseg = new line_segment( i, f );
  }
  line_segment ls(){return linseg;}
  boolean root(){ return true; }
  void display(){
    linseg.display(); 
  }
}

class branch extends E{
  float lerp, d, a;
  branch( line_segment l, float r, float d, float a ){
    linseg = l;
    lerp = r;
    this.d = d;
    this.a = a;
    this.assemble();
  }
  line_segment ls(){
    return this.assemble();
  }
  line_segment assemble(){
    i = PVector.lerp( linseg.i(), linseg.f(), lerp );
    float D = d*linseg.length();
    float A = linseg.heading() - a;
    f = new PVector( i.x + D*cos(A), i.y + D*sin(A) );
    return new line_segment( i, f );
  }
  branch sub_branch(){ return new branch( this.assemble(), lerp, d, a ); }
  void display(){
    this.assemble().display();
  }
  void set_f( PVector v ){
    f = v.get();
    d = i.dist( v ) / ref.length();
    a = ref.heading() - atan2( v.y - i.y, v.x - i.x );
  }
  boolean root(){ return false; }
}