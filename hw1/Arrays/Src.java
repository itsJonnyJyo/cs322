import java.util.ArrayList;

abstract class Value {
  abstract String show();

  boolean asBool() {
    System.out.println("ABORT: Boolean value expected");
    System.exit(1);
    return true; // should not be reached
  }


  int asInt() {
    System.out.println("ABORT: Int value expected");
    System.exit(1);
    return 42; // should not be reached
  }

  Value enter(Value val) {
    System.out.println("ABORT: function value expected");
    System.exit(1);
    return null; //not reached
  }

  int length() {
    System.out.println("ABORT: array value expected");
    System.exit(1);
    return 42; //not reached
  }

  Value nth(int n) {
    System.out.println("ABORT: array value expected");
    System.exit(1);
    return null; //not reached
  }
  
  Value plus(Value that) {
    System.out.println("ABORT: ");
    System.exit(1);
    return null;
  }

  Value iPlus(IValue that) {
    System.out.println("ABORT: ");
    System.exit(1);
    return null;
  }
  
  Value aPlus(AValue that) {
    System.out.println("ABORT: ");
    System.exit(1);
    return null;
  }
}

class BValue extends Value {
  private boolean b;
  BValue(boolean b) { this.b = b; };
  
  String show() { return Boolean.toString(b); }

  boolean asBool() { return b; }
}

class IValue extends Value {
  private int i;
  IValue(int i) { this.i = i; }

  String show() { return Integer.toString(i); }

  int asInt() { return i; }

  Value plus(Value that) {
    return that.iPlus(this);
  }

  Value iPlus(IValue that) {
    IValue sum = new IValue (this.asInt() + that.asInt());
    return sum;
  }

  Value aPlus(AValue that) {
    SingleValue arr = new SingleValue(this);
    ConcatValue temp = new ConcatValue(that, arr);
    
    Value[] vals = new Value[temp.length()];
    for (int i=0; i<temp.length(); i++) {
      if (temp.nth(i) == null) {
        vals = new Value[temp.length() - 1];
      }
    }
      int k = 0;
      for (int i=0; i<temp.length(); i++) { 
          if (temp.nth(i) != null) {
            vals[k] = temp.nth(i);
            k++;
        }
      }
    
    return new MultiValue(vals);
    
  }
}

class FValue extends Value {
  private Env     env;
  private String  arg;
  private Expr    body;

  FValue(Env env, String arg, Expr body) {
    this.env = env; this.arg = arg; this.body = body;
  }

  Value enter(Value val) {
    return body.eval(new ValEnv(arg, val, env));
  }
  
  String show() {
    return "<function>";
  }
}

abstract class AValue extends Value {
  /* Return the length (i.e., number of values) in this array.
   */
  abstract int length();

  /* Return the value at the nth position in this array;
   *  valid indeces run from 0 to length()-1.
   */
  abstract Value nth(int n);

  /* Utility method to check that an index is in range.
   */ 
  void rangeCheck(int n) {
    if (n<0 || n>=length()) {
      System.out.println("ABORT: index out of bounds");
      System.exit(1);
    }
  }

  abstract String show2();



  Value plus(Value that) {
    return that.aPlus(this);
  }

  Value iPlus(IValue that) {
    
    SingleValue arr = new SingleValue(that);
    return this.aPlus(arr);
    
  }

  Value aPlus(AValue that) {
    ConcatValue temp = new ConcatValue(that, this);

    Value[] vals = new Value[temp.length()];
    for (int i=0; i<temp.length(); i++) {
      if (temp.nth(i) == null) {
        vals = new Value[temp.length() - 1];
      }
    }
      int k = 0;
      for (int i=0; i<temp.length(); i++) { 
          if (temp.nth(i) != null) {
            vals[k] = temp.nth(i);
            k++;
        }
      }
    return new MultiValue(vals); 
    
  }

}

//Arrays with ONE element:
class SingleValue extends AValue {
  private Value val;
  SingleValue(Value val) { this.val = val; }
  int length() { return 1; }
  Value nth(int n) { rangeCheck(n); return val; }

  String show() {
    //return "<SingleValue>";
    return "[" + this.show2() + "]";
  }

  String show2() {
    return val.show();
  }
}

//Arrays with an arbitrary, but specific list of elements:
class MultiValue extends AValue {
  private Value[] vals;
  MultiValue(Value[] vals) { this.vals = vals; }
  int length() { return vals.length; }
  Value nth(int n) { rangeCheck(n); return vals[n]; }

  String show() {
    //return "<MultiValue>";
    return "[" + this.show2() + "]";
  }

  String show2() {
    StringBuilder elements = new StringBuilder();
    for (int i=0; i<vals.length; i++) {
      if (vals[i] == null) {
        i++;
      }
      if (i>0) { elements.append(", "); }
      elements.append(vals[i].show());
    }
    return elements.toString();
  }
}

//Arrays containing a contiguous range of integers:
class RangeValue extends AValue {
  private int lo;
  private int hi;
  private int len;
  RangeValue (int lo, int hi) {
    this.lo = lo;
    this.hi = hi;
    this.len = (hi>=lo) ? (1+hi-lo) : 0;
  }
  int length() {return len;}
  Value nth(int n) {rangeCheck(n); return new IValue(lo+n); }

  String show() {
    //return "<RangeValue>";
    return "[" + this.show2() + "]";
  }

  String show2() {
    StringBuilder elements = new StringBuilder();
    int temp;
    for (int i=0; i<len; i++) {
      if (i>0) { elements.append(", "); }
      temp = this.lo + i;
      elements.append(Integer.toString(temp));
    }
    return elements.toString();
  }
}

//Arrays that are made up by concatenating other arrays;
class ConcatValue extends AValue {
  // Elements of the left array come before the elements
  // of the right array in the conbined AValue:

  private AValue left;
  private AValue right;
  private int    llen; //left length
  private int    len;  //total length
  ConcatValue(AValue left, AValue right) {
    this.left  = left;
    this.right = right;
    this.llen  = left.length();
    this.len   = llen + right.length();
  }
  int length() { return len; }
  Value nth(int n) {
    return (n<llen) ? left.nth(n) : right.nth(n-llen);
  }

  String show() {
    //return "<ConcatValue>";
    return "[" + this.show2() + "]";
  }

  String show2() {
    return left.show2() + ", " + right.show2();
  }

}


//____________________________________________________________________________
// Expr ::= Var
//        |  Int
//        |  Expr + Expr
//        |  Expr - Expr
//        |  Expr < Expr
//        |  Expr == Expr

abstract class Expr {
  abstract Value eval(Env env);
  abstract String show();

  Env evalRef(Env env) {
    return new ValEnv("", eval(env), null);
  }
}

class Var extends Expr {
  private String name;
  Var(String name) { this.name = name; }

  Value eval(Env env) {
    return Env.lookup(env, name).getValue(); 
  }


  Env evalRef(Env env) {
    //return a reference to this variable:
    return Env.lookup(env, name);
  }

  String show() { return name; }
}

//Array Expr's

class Array extends Expr {
  private Expr[] elements;
  Array(Expr[] e) { this.elements = e; }

  Value eval(Env env) {
    if (elements.length > 1) {
      //ArrayList<Value> things = new ArrayList<Value>();
      Value[] vals = new Value[elements.length];
      for (int i=0; i<elements.length; i++) {
        //things.add(elements[i].eval(env));
        vals[i] = elements[i].eval(env);
      }
      //Value[] vals = things.toArray(); returns type 'Object[]' which is incompatible
      return new MultiValue(vals);
    }
    else if (elements.length == 1) {
      return new SingleValue(elements[0].eval(env));
    }
    else {
      return new SingleValue(null);
    }
  }

 
  String show() {
    return ("[" + this.show2() + "]");
  }

  String show2() {  
    StringBuilder array = new StringBuilder();
    for (int i=0; i<elements.length; i++) {
      if (i>0) { array.append(", "); }
      array.append(elements[i].show());
    }
    return array.toString();  
  }
}

class Range extends Expr {
  private Expr e1;
  private Expr e2;

  Range(Expr e1, Expr e2) { this.e1 = e1; this.e2 = e2; }

  Value eval(Env env) {
    int e1Val = e1.eval(env).asInt();
    int e2Val = e2.eval(env).asInt();
    Value[] vals = new Value[e2Val-e1Val+1];
    int i = 0;
    while (e1Val<e2Val) {
      vals[i] = new IValue(e1Val++);
      i++;
    }
    vals[i] = new IValue(e2Val);
    return new MultiValue(vals);

  }

  String show() {
    return ("[" + e1.show() + ".." + e2.show() + "]");
  }
}

class Length extends Expr {
  private Expr e;
  Length(Expr e) { this.e = e; }

  Value eval(Env env) {
    return new IValue(e.eval(env).length());
  }

  String show() {
    return ("length(" + e.show() + ")");
  }
}

class Nth extends Expr {
  private Expr e1;
  private Expr e2;
  Nth(Expr e1, Expr e2) { this.e1 = e1; this.e2 = e2; }

  Value eval(Env env) {
    return (e1.eval(env).nth(e2.eval(env).asInt()));
  }

  String show() {
    return(e1.show() + "[" + e2.show() + "]");
  }
}

//Function Expr's
class Lambda extends Expr {
  private String var;
  private Expr   body;
  Lambda(String var, Expr body) { this.var = var; this.body = body; }

  Value eval(Env env) {
    return new FValue(env, var, body);
  }

  String show() { return "(\\" + var + " -> " + body.show() + ")"; }
}

class Apply extends Expr {
  private Expr fun, arg;
  Apply(Expr fun, Expr arg) { this.fun = fun; this.arg = arg; }

  Value eval(Env env) {
    return fun.eval(env).enter(arg.eval(env));
  }

  String show() { return "(" + fun.show() + " @ " + arg.show() + ")"; }

}


class Int extends Expr {
  private int num;
  Int(int num) { this.num = num; }

  Value eval(Env env) { return new IValue(num); }
  String show() { return Integer.toString(num); }
}

//Binary Expr's
class Plus extends Expr {
  private Expr l, r;
  Plus(Expr l, Expr r) { this.l = l; this.r = r; }

  Value eval(Env env) { return l.eval(env).plus(r.eval(env)); }
  //Value eval(Env env) { return new IValue(l.eval(env).asInt() + r.eval(env).asInt()); }
  String show() { return "(" + l.show() + " + " + r.show() + ")"; }
}

class Mult extends Expr {
  private Expr l, r;
  Mult(Expr l, Expr r) { this.l = l; this.r = r; }

  Value eval(Env env) { return new IValue(l.eval(env).asInt() * r.eval(env).asInt()); }
  String show() { return "(" + l.show() + " * " + r.show() + ")"; }
}

class Minus extends Expr {
  private Expr l, r;
  Minus(Expr l, Expr r) { this.l = l; this.r = r; }

  Value eval(Env env) { return new IValue(l.eval(env).asInt() - r.eval(env).asInt()); }
  String show() { return "(" + l.show() + " - " + r.show() + ")"; }
}

//Boolean Expr's
class LT extends Expr {
  private Expr l, r;
  LT(Expr l, Expr r) { this.l = l; this.r = r; }

  Value eval(Env env) { return new BValue(l.eval(env).asInt() < r.eval(env).asInt()); }
  String show()  { return "(" + l.show() + " < " + r.show() + ")"; }
}

class EqEq extends Expr {
  private Expr l, r;
  EqEq(Expr l, Expr r) { this.l = l; this.r = r; }

  Value eval(Env env) { return new BValue(l.eval(env).asInt() == r.eval(env).asInt()); }
  String show()  { return "(" + l.show() + " == " + r.show() + ")"; }
}

//____________________________________________________________________________
// Stmt  ::= Seq Stmt Stmt
//        |  Var := Expr
//        |  While Expr Stmt
//        |  If Expr Stmt Stmt
//        |  Print Expr

abstract class Stmt {
  abstract Env exec(Program prog, Env env);
  abstract void print(int ind);

  static void indent(int ind) {
    for (int i=0; i<ind; i++) {
      System.out.print(" ");
    }
  }
}

class Foreach extends Stmt {
  private String i;    // variable to be used for the index
  private String v;    // variable to be used for corresponding value
  private Expr   arr;  // the array expression
  private Stmt   body; // the loop body

  Foreach(String i, String v, Expr arr, Stmt body) {
    this.i    = i;
    this.v    = v;
    this.arr  = arr;
    this.body = body;
  }
  

  Env exec(Program prog, Env env) {
    Value safeArr = arr.eval(env);
    Value[] vals = new Value[safeArr.length()];
    for (int idx=0; idx<vals.length; idx++) {
      vals[idx] = safeArr.nth(idx);
    }
    //Value iVar = Env.lookup(env, i).getValue();
    
    Env env2;
    int idx = 0;
    while (idx<vals.length) {
      env2 = new ValEnv(i, new IValue(idx), new ValEnv(v, vals[idx], env));
      body.exec(prog, env2);
      idx++;
    }
    return env;
    /*
    Stmt iVar = new VarDecl(i, new Int(0));
    Stmt vVar = new VarDecl(v, new Int(0));
    Env env2 = vVar.exec(prog, iVar.exec(prog, env));
    int idx = 0;
    Value vv = null;
    Value ii = null;
    while (idx<arr.eval(env).length()) {
      vv = arr.eval(env).nth(idx);
      iVar = new Assign(i, new Int(idx));
      vVar = new Assign(v, vv.eval(env));
      env2 = vVar.exec(prog, iVar.exec(prog, env));
      body.exec(prog, env2);
      idx++;
    }
    */
    //while (i<arr.length())
    //v = element of arr at i .eval(env)
    //Assign env2 = new Assign(v, new Nth(arr, new Int(i)));
    //body.exec(prog, env2.exec(prog, exec));
    //inc i
  }

  void print(int ind) {
    indent(ind);
    System.out.println("foreach " + i + " => " + v
                           + " in " + arr.show() + " {");
    body.print(ind+2);
    indent(ind);
    System.out.println("}");
  }
}

class Seq extends Stmt {
  private Stmt l, r;
  Seq(Stmt l, Stmt r) { this.l = l; this.r = r; }

  Env exec(Program prog, Env env) {
    return r.exec(prog, l.exec(prog, env));
  }

  void print(int ind) {
    l.print(ind);
    r.print(ind);
  }
}

class Assign extends Stmt {
  private String lhs;
  private Expr  rhs;
  Assign(String lhs, Expr rhs) {
    this.lhs = lhs; this.rhs = rhs;
  }

  Env exec(Program prog, Env env) {
    Env.lookup(env, lhs).setValue(rhs.eval(env));  
    return env; 
  }

  void print(int ind) {
    indent(ind);
    System.out.println(lhs + " = " + rhs.show() + ";");
  }
}

class While extends Stmt {
  private Expr test;
  private Stmt  body;
  While(Expr test, Stmt body) {
    this.test = test; this.body = body;
  }

  Env exec(Program prog, Env env) {
    while (test.eval(env).asBool()) {
      body.exec(prog, env);
    }
    return env;
  }

  void print(int ind) {
    indent(ind);
    System.out.println("while (" + test.show() + ") {");
    body.print(ind+2);
    indent(ind);
    System.out.println("}");
  }
}

class If extends Stmt {
  private Expr test;
  private Stmt  t, f;
  If(Expr test, Stmt t, Stmt f) {
    this.test = test; this.t = t; this.f = f;
  }

  Env exec(Program prog, Env env) {
    if (test.eval(env).asBool()) {
      t.exec(prog, env);
    } else {
      f.exec(prog, env);
    }
    return env;
  }

  void print(int ind) {
    indent(ind);
    System.out.println("if (" + test.show() + ") {");
    t.print(ind+2);
    indent(ind);
    System.out.println("} else {");
    f.print(ind+2);
    indent(ind);
    System.out.println("}");
  }
}

class Print extends Stmt {
  private Expr exp;
  Print(Expr exp) { this.exp = exp; }

  Env exec(Program prog, Env env) {
    System.out.println("Output: " + exp.eval(env).show());
    return env;  
  }

  void print(int ind) {
    indent(ind);
    System.out.println("print " + exp.show() + ";");
  }
}

class VarDecl extends Stmt {
  private String var;
  private Expr   expr;
  VarDecl(String var, Expr expr) { this.var = var; this.expr = expr; }

  Env exec(Program prog, Env env) {
    return new ValEnv(var, expr.eval(env), env); 
  }

  void print(int ind) {
    indent(ind);
    System.out.println("var " + var + " = " + expr.show() + ";");
  }  
}

class Call extends Stmt {
  private String name;
  private Expr[] actuals;
  Call(String name, Expr[] actuals) {
    this.name = name; this.actuals = actuals;
  }

  Env exec(Program prog, Env env) {
    prog.call(env, name, actuals);
    return env;
  }

  void print (int ind) {
    indent(ind);
    System.out.print(name + "(");
    for (int i=0; i<actuals.length; i++) {
      if (i>0) {
        System.out.print(", ");
      }
      System.out.print(actuals[i].show());
    }
    System.out.println(");");
  }
}

class Program {
  private Proc[] procs;
  private Stmt body;
  
  Program(Proc[] procs, Stmt body) {
    this.procs = procs; this.body = body;
  }

  Program(Stmt body) {
    this(new Proc[] {}, body);
  }

  void run() {
  body.exec(this, null);
  }

  void call(Env env, String name, Expr[] actuals) {
    for (int i=0; i<procs.length; i++) {
      if (name.equals(procs[i].getName())) {
        procs[i].call(this, env, actuals);
        return;
      }
    }
    System.out.println("ABORT: Cannot find procedure " + name);
    System.exit(1);
  }
  
  void print() {
    for (int i=0; i<procs.length; i++) {
      procs[i].print(4);
    }
    body.print(4);
    System.out.println();
  }
}

class Formal {
  protected String name;

  Formal(String name) {
    this.name = name;
  }

  public String toString() {
    return name;
  }
  Env extend(Env env, Expr actual, Env newenv) {
    return new ValEnv(name, actual.eval(env), newenv);
  }
}

class ByRef extends Formal {
  ByRef(String name) { super(name); }

  public String toString() {
    return "ref " + name;
  }

  Env extend(Env env, Expr actual, Env newenv) {
    return new RefEnv(name, actual.evalRef(env), newenv);
  }
}

class Proc {
  private String   name;
  private Formal[] formals;
  private Stmt     body;

  Proc(String name, Formal[] formals, Stmt body) {
    this.name = name; this.formals = formals; this.body = body;
  }

  String getName() { return name; }
  
    
  void call(Program prog, Env env, Expr[] actuals) {
    if (actuals.length!=formals.length) {
      System.out.println("ABORT: Wrong number of args for " + name);
      System.exit(1);
    }
    Env newenv = null;
    for (int i=0; i<actuals.length; i++) {
      newenv = formals[i].extend(env, actuals[i], newenv);
      //newenv = new ValEnv(formals[i], actuals[i].eval(env), newenv);
    }
    body.exec(prog, newenv);
  }

  void print(int ind) {
    Stmt.indent(ind);
    System.out.print("procedure " + name + "(");
    for (int i=0; i<formals.length; i++) {
      if (i>0) {
        System.out.print(", ");
      }
      System.out.print(formals[i]);
    } 
    System.out.println(") {");

    body.print(ind+2);

    Stmt.indent(ind);
    System.out.println("}");
  }
}







