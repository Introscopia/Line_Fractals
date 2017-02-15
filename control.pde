void mouseDragged(){
  if( mouseButton == RIGHT && drag ){
    e.get(dragging).set_f( new PVector( mouseX, mouseY ) );
  }
}
void mousePressed(){
  if( click ){
    PVector M = new PVector( mouseX, mouseY ); 
    if(  mouseButton == RIGHT && e.size() > 0 ){
      FloatList dists = new FloatList();  
      for(int i = 0; i < e.size(); i++){
        dists.append( e.get(i).f.dist( M ) );    
      }
      float min = dists.min();
      int I = 0;
      for(int i = 0; i < dists.size(); i++){
        if( dists.get(i) == min && min < 30){
          dragging = i;
          drag = true;
          break;
        }
      }
    }
    else if( mouseButton == LEFT ){
      if( first ){
        if( making ){
          e.add( new root( p, M ) );
          making = false;
          first = false;
        }
        else{
          p = new PVector(mouseX, mouseY );
          making = true;
        }
      }
      else{
        if( making ){
          PVector o = PVector.lerp( ref.i(), ref.f(), lerp );
          float d = o.dist( M ) / ref.length();
          float a = ref.heading() - atan2( M.y - o.y, M.x - o.x );
          e.add( new branch( ref, lerp, d, a ) );
          making = false;
        }
        else{
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
          p = c.get();
          lerp = e.get(I).ls().i().dist( c ) / e.get(I).ls().length();
          ref = e.get(I).ls();
          making = true;
        }
      }
    }
    click = false;
  }
}
void mouseReleased(){
  click = true;
  drag = false;
}

void mouseWheel(MouseEvent E) {
  float wheel = E.getAmount();
  lvl = round(constrain( lvl + wheel, 1, 300 ));
}

void keyPressed(){
  if( key == BACKSPACE ){
    if( e.size() > 0 ){
      e.remove( e.size() -1 ); 
      if( e.size() == 0 ) first = true;
    }
  }
  else if( key == 'p' || key == 'P' ) save("print "+year()+"-"+month()+"-"+day()+" "+hour()+"."+minute()+"."+second()+".png");
  else if( key == ESC ){
    making = false;
    key = '0';
  }
}