class line_segment{
  public float a, b, xi, xf;
  boolean vertical, rightward;
  public float yi, yf;
  line_segment(){}
  line_segment( PVector i, PVector f ){
    if( 12*abs(i.x-f.x) < abs(i.y-f.y) ){//i.x == f.x ){
      vertical = true;
      xi = i.x;
      rightward = true;
      if( f.y < i.y ){
        PVector temp = i.get();
        i = f.get();
        f = temp.get();
        rightward = false;
      }
      yi = i.y;
      yf = f.y;
    }
    else{
      rightward = true;
      if( f.x < i.x ){
        PVector temp = i.get();
        i = f.get();
        f = temp.get();
        rightward = false;
      }
      vertical = false;
      xi = i.x;
      xf = f.x;
      yi = i.y;
      yf = f.y;
      a = (f.y - i.y) / (f.x - i.x);
      b = i.y - (a * i.x);
    }
  }
  void print_it(){
    println( a, b, xi, xf,  yi, yf, vertical, rightward );
  }
  
  PVector i(){
    if( rightward ){
      if( vertical ) return new PVector( xi, yi );
      else return new PVector( xi, yi );//a*xi + b );
    }
    else{
      if(vertical) return new PVector( xi, yf );
      else return new PVector( xf, yf );//a*xf + b );
    }
  }
  
  PVector f(){
    if( rightward ){
      if( vertical ) return new PVector( xi, yf );
      else return new PVector( xf, yf );//a*xf + b );
    }
    else{
      if(vertical) return new PVector( xi, yi );
      else return new PVector( xi, yi );//a*xi + b );
    }
  }
  
  PVector midpoint(){
    if( vertical ) return new PVector( xi, yi + (yf-yi)/2f );
    else{
      float x = xi + (xf-xi)/2f;
      return new PVector( x, a*x + b );
    }
  }
  
  float length(){
    if( vertical ){
      return (yf - yi);
    }
    else{
      float w = xf - xi;
      return sqrt( sq(w) + sq(a*w) );
    }
  }
  /*
  if( (rightward && p.y > this.i().y && p.y < this.f().y) ||
          (!rightward && p.y < this.i().y && p.y > this.f().y) )
          */
  PVector projection( PVector p ){
    if( vertical ){
      if( (rightward && p.y > yi && p.y < yf) || (!rightward && p.y < yi && p.y > yf) ) return new PVector( xi, p.y );
      float id = p.dist( this.i() );
      float fd = p.dist( this.f() );
      if( id < fd ) return this.i();
      else return this.f();
    }
    else{
      if( a == 0 ){
        if( (rightward && p.x > xi && p.x < xf) || (!rightward && p.x < xi && p.x > xf) ) return new PVector( p.x, yi );
        float id = p.dist( this.i() );
        float fd = p.dist( this.f() );
        if( id < fd ) return this.i();
        else return this.f();
      }
      else{
        float oa = -(1/a);
        float ob = p.y - (oa * p.x);
        float x = (ob - b) / (a - oa);
        PVector c = new PVector();
        if( ( (x < xf) && (x > xi) ) ) return new PVector( x, a*x + b ) ;
        float id = p.dist( this.i() );
        float fd = p.dist( this.f() );
        if( id < fd ) return this.i();
        else return this.f();
      }
    }
  }
  
  float dist( PVector p ){
    if( vertical ){
      if( (rightward && p.y > yi && p.y < yf) || (!rightward && p.y < yi && p.y > yf) ) return abs( p.x - xi );
      else return min( p.dist( this.i() ), p.dist( this.f() ) );
    }
    else{
      if( a == 0 ){
        if( (rightward && p.x > xi && p.x < xf) || (!rightward && p.x < xi && p.x > xf) ) return abs( p.y - yi );
        else return min( p.dist( this.i() ), p.dist( this.f() ) );
      }
      else{
        float oa = -(1/a);
        float ob = p.y - (oa * p.x);
        float x = (ob - b) / (a - oa);
        PVector c = new PVector();
        if( ( (x < xf) && (x > xi) ) ){
          c = new PVector( x, a*x + b ) ;
          return c.dist( p );
        }
        else return min( p.dist( this.i() ), p.dist( this.f() ) );
      }
    }
  }
  
  float orthogonal_heading( PVector p ){
    if( vertical ){
      if( (rightward && p.y > yi && p.y < yf) || (!rightward && p.y < yi && p.y > yf) ){
        if( p.x < this.xi ) return 0;
        else return PI;
      }
      else return 0;
    }
    else{
      if( a == 0 ){
        if( p.y < b ) return HALF_PI;
        else return -HALF_PI;
      }
      else{
        float oa = -(1/a);
        float ob = p.y - (oa * p.x);
        float x = (ob - b) / (a - oa);
        PVector c = new PVector();
        if( ( (x < xf) && (x > xi) ) ) c = new PVector( x, a*x + b ) ;
        return atan2( c.y - p.y, c.x - p.x );
      }
    }
  }
  
  float heading(){
    if( vertical ){
      if( rightward ) return HALF_PI;
      else return -HALF_PI;
    }
    else{
      float h = (rightward)? atan(a) : atan(a)+PI;
      if( abs(h) > PI ) h = -(TWO_PI - abs(h));
      return h;
    }
  }
  
  line_segment displaced( float d, float a ){
    PVector dis = new PVector( d*cos(a), d*sin(a) );
    line_segment out = new line_segment( PVector.add( this.i(), dis ), PVector.add( this.f(), dis ) );
    out.rightward = this.rightward;
    out.vertical = this.vertical;
    return out;
  }
  line_segment displaced( PVector k, PVector l ){
    PVector dis = l.sub( k );
    line_segment out = new line_segment( PVector.add( this.i(), dis ), PVector.add( this.f(), dis ) );
    out.rightward = this.rightward;
    out.vertical = this.vertical;
    return out;
  }
  
  PVector intersection( line_segment ls ){
    if( vertical && !ls.vertical ){
      float y = (ls.a * xi) + ls.b;
      if( (y > yi && y < yf) && (ls.xi <= xi && ls.xf >= xi) ) return new PVector( xi, y );
      else return null;
    }
    else if( !vertical && ls.vertical ){
      float y = (a * ls.xi) + b;
      if( (y > ls.yi && y < ls.yf) && (xi <= ls.xi && xf >= ls.xi) ) return new PVector( ls.xi, y );
      else return null;
    }
    else if( !vertical && !ls.vertical ) {
      float x = (ls.b - b) / (a - ls.a);
      if( ( (x < xf) && (x > xi) ) && ( (x < ls.xf) && (x > ls.xi) ) ) return new PVector( x, a*x + b );
      else return null;
    }
    else{// if( vertical && ls.vertical ){
      return null;
    }
  }
  PVector unbounded_intersection( line_segment ls ){
    if( vertical && !ls.vertical ){
      float y = (ls.a * xi) + ls.b;
      return new PVector( xi, y );
    }
    else if( !vertical && ls.vertical ){
      float y = (a * ls.xi) + b;
      return new PVector( ls.xi, y );
    }
    else if( !vertical && !ls.vertical ) {
      float x = (ls.b - b) / (a - ls.a);
      return new PVector( x, a*x + b );
    }
    else{
      return null;
    }
  }
  
  void display(){
    if(vertical) line(xi, yi, xi, yf ); 
    else line(xi, a*xi + b, xf, a*xf + b ); 
  }
  void display(PGraphics pg){
    if(vertical) pg.line(xi, yi, xi, yf ); 
    else pg.line(xi, a*xi + b, xf, a*xf + b ); 
  }
}