public class RangeColor {
  int from;
  int to;
  
  public RangeColor(int from, int to, boolean reversed){
    if(reversed){
      this.from = to;
      this.to = from; 
    }
    else{
      this.from = from;
      this.to = to;
    }
  }
}
