class Mainq3test {
  public static void main(String[] args) {
    
    //create an expression array
    Expr e1[] = new Expr[2];
    e1[0] = new Int(3);
    e1[1] = new Int(5);

    //this example creates one single value array and then prints it
    Stmt s = 
    //everything basically has to be inside of new Seq
    //every new seq takes two parameters. either a new Seq, new VarDecl, or New Print
    new Seq(new VarDecl("array", new Array(e1)),
    //You use new Var to look up variables that have already been created
    new Print(new Var("array")));
  }
}
