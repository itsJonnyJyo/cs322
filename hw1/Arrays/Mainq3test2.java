class Mainq3test2 {
  public static void main(String[] args) {
    
    //create an expression array
    Expr e1[] = new Expr[1];
    e1[0] = new Int(3);
    Expr e2 = new Int(4);
    Expr e3 = new Int(7);
    Expr e4 = new Array(e1);
    Expr e5 = new Int(1);

    Stmt s = 
    //everything basically has to be inside of new Seq
    //every new seq takes two parameters. either a new Seq, new VarDecl, or New Print
    //you can keep chainging new Seq to do more stuff
    new Seq(new VarDecl("array", new Array(e1)),
    new Seq(new VarDecl("range", new Range(e2, e3)),
    //You use new Var to look up variables that have already been created
    //this is the trickiest part. Look at how Length is called
    new Seq(new Print(new Length(new Var("range"))),
    new Seq(new Print(new Nth(new Var("range"),e5)),
    new Print(new Var("range"))))));
    
    Program prog = new Program(s);

    System.out.println("Complete program is:");
    prog.print();
 
    System.out.println("Running program:");
    prog.run();

    System.out.println("Done!");    

  }
}
