//> using scala 2.13.10

import scala.util.{Failure, Try}
object Tools {
  implicit class MustBeOp[A](x: => A) {
    def mustBe[B >: A]: B = { assert(x.isInstanceOf[B]); x : B }
    def equal[B >: A](y: B): Unit = assert(x == y)
    def mustThrow[T](message: String): Unit = assert(Try(x) match { case Failure(t: T) if t.getMessage == message => true } )
  }
}

import Tools._

object Example {


// Code snippet 00001:
import java.nio.file.{Files, Paths}
val p = Paths.get("config_location.txt")
val configLocation = Paths.get(new String(Files.readAllBytes(p)))
val config = new String(Files.readAllBytes(configLocation))

// Code snippet 00002:
sealed trait PrgFile
final case class Val(s: String)   extends PrgFile
final case class Path(p: PrgFile) extends PrgFile
final case class Read(p: PrgFile) extends PrgFile

// Code snippet 00003:
val prgFile: PrgFile = Read(Path(Read(Path(Val("config_location.txt")))))

// Code snippet 00004:
def runFile: PrgFile => String = {
  case Val(s)          => s
  case Path(p)         => "path=" + runFile(p)                
  case Read(Path(p))   => new String(Files.readAllBytes(Paths.get(runFile(p))))
  case x               => throw new Exception(s"Illegal PrgFile operation: $x")
}

// Code snippet 00005:
runFile(prgFile)
 .mustBe[String] equal "version = 1"

// Code snippet 00006:
final case class Complex(x: Double, y: Double) {
  def +(other: Complex): Complex = Complex(x + other.x, y + other.y)
  def *(other: Complex): Complex = Complex(x * other.x - y * other.y, x * other.y + y * other.x)
  def conj: Complex = Complex(x, -y)
  def phase: Double = math.atan2(y, x)         
  def rotate(alpha: Double): Complex = this * Complex(math.cos(alpha), math.sin(alpha))
}

val a = Complex(1, 2)          
val b = a * Complex(3, -4)     
val c = b.conj                 

c
 .mustBe[Complex] equal Complex(11.0, -2.0)

c.rotate(Complex(0, 1).phase) 
 .mustBe[Complex] equal Complex(2.000000000000001, 11.0)

// Code snippet 00007:
sealed trait PrgComplex
final case class Val(c: Complex)                      extends PrgComplex
final case class Add(p1: PrgComplex, p2: PrgComplex)  extends PrgComplex
final case class Mul(p1: PrgComplex, p2: PrgComplex)  extends PrgComplex
final case class Conj(p: PrgComplex)                  extends PrgComplex
final case class Phase(p: PrgComplex)                 extends PrgComplex
final case class Rotate(p: PrgComplex, a: PrgComplex) extends PrgComplex

// Code snippet 00008:
val prgComplex1: PrgComplex = Conj(Mul(Val(Complex(1, 2)), Val(Complex(3, -4))))
val prgComplex2: PrgComplex = Rotate(prgComplex1, Phase(Val(Complex(0, 1))))

// Code snippet 00009:
def runComplex: PrgComplex => Complex = {
  case Val(c)             => c
  case Add(p1, p2)        => runComplex(p1) + runComplex(p2)
  case Mul(p1, p2)        => runComplex(p1) * runComplex(p2)
  case Conj(p)            => runComplex(p).conj
  case Phase(p)           => Complex(runComplex(p).phase, 0) 
  case Rotate(p, alpha)   => runComplex(p).rotate(runComplex(alpha).x) 
}

// Code snippet 00010:
runComplex(prgComplex1)
 .mustBe[Complex] equal Complex(11.0, -2.0)

runComplex(prgComplex2)
 .mustBe[Complex] equal Complex(2.000000000000001, 11.0)

// Code snippet 00011:
runFile(Read(Read(Val("file"))))
 .mustThrow[java.lang.Exception]("Illegal PrgFile operation: Read(Read(Val(file)))")

// Code snippet 00012:
import java.nio.file.{Path => JPath}
import java.nio.file.{Files, Paths}
sealed trait PrgFile[A]
final case class Val(s: String)           extends PrgFile[String]
final case class Path(p: PrgFile[String]) extends PrgFile[JPath]
final case class Read(p: PrgFile[JPath])  extends PrgFile[String]

def runFile[A]: PrgFile[A] => A = {
  case Val(s)   => s
  case Path(p)  => Paths.get(runFile(p))
  case Read(p)  => new String(Files.readAllBytes(runFile(p)))
}

// Code snippet 00013:
val prgFile: PrgFile[String] = Read(Path(Read(Path(Val("config_location.txt")))))

runFile(prgFile)
 .mustBe[String] equal "version = 1"
/*
runFile(Read(Read(Val("file"))))
type mismatch;
 found   : Val
 required: PrgFile[java.nio.file.Path]
val res4 = runFile(Read(Read(Val("file"))))
                                ^
Compilation Failed 
*/
// Code snippet 00014:
val prgComplex3: PrgComplex = Rotate(prgComplex1, Val(Complex(0, 1)))     

runComplex(prgComplex3)    
val res5: Complex = Complex(11.0, -2.0)

// Code snippet 00015:
sealed trait PrgComplex[A]
final case class Val(c: Complex)                                       extends PrgComplex[Complex]
final case class Add(p1: PrgComplex[Complex], p2: PrgComplex[Complex]) extends PrgComplex[Complex]
final case class Mul(p1: PrgComplex[Complex], p2: PrgComplex[Complex]) extends PrgComplex[Complex]
final case class Conj(p: PrgComplex[Complex])                          extends PrgComplex[Complex]
final case class Phase(p: PrgComplex[Complex])                         extends PrgComplex[Double]
final case class Rotate(p: PrgComplex[Complex], a: Phase)              extends PrgComplex[Complex]

// Code snippet 00016:
def runComplex[A]: PrgComplex[A] => A = {
  case Val(c)             => c
  case Add(p1, p2)        => runComplex(p1) + runComplex(p2)
  case Mul(p1, p2)        => runComplex(p1) * runComplex(p2)
  case Conj(p)            => runComplex(p).conj
  case Phase(p)           => runComplex(p).phase
  case Rotate(p, alpha)   => runComplex(p).rotate(runComplex(alpha))
}

// Code snippet 00017:
val prgComplex1: PrgComplex[Complex] = Conj(Mul(Val(Complex(1, 2)), Val(Complex(3, -4))))

val prgComplex2: PrgComplex[Complex] = Rotate(prgComplex1, Phase(Val(Complex(0, 1))))

runComplex(prgComplex1)
 .mustBe[Complex] equal Complex(x = 11.0, y = -2.0)

runComplex(prgComplex2)
 .mustBe[Complex] equal Complex(x = 2.000000000000001, y = 11.0)

// Code snippet 00018:
  /*
val prgComplex3 = Rotate(prgComplex1, Val(Complex(0, 1)))
<console>:1: type mismatch;
 found   : Val
 required: PrgComplex[Double]                                                              
  case Phase(p)           => runComplex(p)
                                       ^
Compilation Failed
*/
// Code snippet 00019:
val p = Paths.get("config_location.txt")
val result = if (Files.exists(p)) new String(Files.readAllBytes(p)) else "No file."

// Code snippet 00020:
val p: JPath = runFile(Path(Val("config_location.txt")))
val prg: PrgFile[String] = if (Files.exists(p)) Read(p) else Val("No file.")

// Code snippet 00021:
final case class Val[A](a: A) extends PrgFile[A]

// Code snippet 00022:
  /*
{ p => if (Files.exists(p)) Read(Val(p)) else Val("No file.") }
*/

// Code snippet 00023:
val prg2: PrgFile[JPath] = Path(Val("config.txt"))
val prg: PrgFile[String] = Bind(prg2){ p => if (Files.exists(p)) Read(Val(p)) else Val("No file.") }

// Code snippet 00024:
final case class Bind[A, B](pa: PrgFile[B])(f: B => PrgFile[A]) extends PrgFile[A]

// Code snippet 00025:
sealed trait PrgFile[A]
final case class Val[A](a: A)                                       extends PrgFile[A]
final case class Bind[A, B](pa: PrgFile[B])(val f: B => PrgFile[A]) extends PrgFile[A]
final case class Path(p: PrgFile[String])                           extends PrgFile[JPath]
final case class Read(p: PrgFile[JPath])                            extends PrgFile[String]

def runFile[A]: PrgFile[A] => A = {
  case Val(a)          => a
  case bind@Bind(pa)   => runFile(bind.f(runFile(pa)))
  case Path(p)         => Paths.get(runFile(p))
  case Read(p)         => new String(Files.readAllBytes(runFile(p)))
}

// Code snippet 00026:
val prg: PrgFile[String] = Bind(prg2){ p => if (Files.exists(p)) Read(Val(p)) else Val("No file.") }

// Code snippet 00027:
runFile(prg)
 .mustBe[String] equal "version = 1"

// Code snippet 00028:
sealed trait PrgFile[A] {
  def flatMap[B](f: A => PrgFile[B]): PrgFile[B] = Bind(this)(f)
  def map[B](f: A => B): PrgFile[B] = flatMap(f andThen PrgFile.pure)
}
final case class Val[A](a: A)                                       extends PrgFile[A]
final case class Bind[A, B](pa: PrgFile[B])(val f: B => PrgFile[A]) extends PrgFile[A]
final case class Path(p: PrgFile[String])                           extends PrgFile[JPath]
final case class Read(p: PrgFile[JPath])                            extends PrgFile[String]

object PrgFile {
  def pure[A](a: A): PrgFile[A] = Val(a) 
}

// Code snippet 00029:
val prg: PrgFile[String] = for {
  p <- Path(Val("config.txt"))
  r <- if (Files.exists(p)) Read(Val(p)) else Val("No file.")
} yield r

// Code snippet 00030:
def readFileContents(filename: String): PrgFile[String] = for {
  path <- Path(Val(filename))
  text <- if (Files.exists(path)) Read(Val(path)) else Val("No file.")
} yield text

val prg2: PrgFile[String] = for {
  str <- readFileContents("config.txt")
  result <- if (str.nonEmpty) readFileContents(str) else Val("No filename.")
} yield result

runFile(prg2)
 .mustBe[String] equal "version = 1"

// Code snippet 00031:
final case class Path(p: String) extends PrgFile[JPath]
final case class Read(p: JPath)  extends PrgFile[String]

// Code snippet 00032:
def runFile[A]: PrgFile[A] => A = {
  case Val(a)          => a
  case bind@Bind(pa)   => runFile(bind.f(runFile(pa)))
  case Path(p)         => Paths.get(p)
  case Read(p)         => new String(Files.readAllBytes(p))
}

// Code snippet 00033:
sealed trait PrgComplex[A] {
  def flatMap[B](f: A => PrgComplex[B]): PrgComplex[B] = Bind(this)(f)
  def map[B](f: A => B): PrgComplex[B] = flatMap(f andThen PrgComplex.pure)
}
object PrgComplex {
  def pure[A](a: A): PrgComplex[A] = Val(a)
}

final case class Val[A](a: A)                                             extends PrgComplex[A]
final case class Bind[A, B](pa: PrgComplex[B])(val f: B => PrgComplex[A]) extends PrgComplex[A]
final case class Add(x: Complex, y: Complex)                              extends PrgComplex[Complex]
final case class Mul(x: Complex, y: Complex)                              extends PrgComplex[Complex]
final case class Conj(x: Complex)                                         extends PrgComplex[Complex]
final case class Phase(p: Complex)                                        extends PrgComplex[Double]
final case class Rotate(p: Complex, p: Phase)                             extends PrgComplex[Complex]

def runComplex[A]: PrgComplex[A] => A = {
  case Val(a)                => a
  case bind@Bind(pa)         => runComplex(bind.f(runComplex(pa)))
  case Add(p1, p2)           => p1 + p2
  case Mul(p1, p2)           => p1 * p2
  case Conj(p)               => p.conj
  case Phase(p)              => p.phase
  case Rotate(p, Phase(a))   => p.rotate(a.phase)
}

// Code snippet 00034:
sealed trait PrgFileC[A]
final case class Path(p: String) extends PrgFileC[JPath]
final case class Read(p: JPath)  extends PrgFileC[String]
  
def runFileC[A]: PrgFileC[A] => A = {
  case Path(p)   => Paths.get(p)
  case Read(p)   => new String(Files.readAllBytes(p))
}

// Code snippet 00035:


final case class Val[A](a: A) extends PrgFile[A]
final case class Bind[A, B](pa: PrgFile[B])(val f: B => PrgFile[A]) extends PrgFile[A]
final case class Op[A](op: PrgFileC[A]) extends PrgFile[A]  

def runFile[A]: PrgFile[A] => A = {
  case Val(a)          => a
  case bind@Bind(pa)   => runFile(bind.f(runFile(pa)))
  case Op(op)          => runFileC(op) 
}

// Code snippet 00036:


final case class Val[A](a: A) extends PrgComplex[A]
final case class Bind[A, B](pa: PrgComplex[B])(val f: B => PrgComplex[A]) extends PrgComplex[A]
final case class Op[A](op: PrgComplexC[A]) extends PrgComplex[A]     

def runComplex[A]: PrgComplex[A] => A = {
  case Val(a)             => a
  case bind@Bind(pa)      => runComplex(bind.f(runComplex(pa)))
  case Op(op)             => runComplexC(op)    

sealed trait PrgComplexC[A]
final case class Add(x: Complex, y: Complex)      extends PrgComplexC[Complex]
final case class Mul(x: Complex, y: Complex)      extends PrgComplexC[Complex]
final case class Conj(x: Complex)                 extends PrgComplexC[Complex]
final case class Phase(p: Complex)                extends PrgComplexC[Double]
final case class Rotate(p: Complex, alpha: Phase) extends PrgComplexC[Complex]
 
def runComplexC[A]: PrgComplexC[A] => A = {
  case Add(p1, p2)           => p1 + p2
  case Mul(p1, p2)           => p1 * p2
  case Conj(p)               => p.conj
  case Phase(p)              => p.phase
  case Rotate(p, Phase(a))   => p.rotate(a.phase)
}

// Code snippet 00037:
sealed trait MonadDSL[F[_], A] {
  def flatMap[B](f: A => MonadDSL[F, B]): MonadDSL[F, B] = Bind(this)(f)
  def map[B](f: A => B): MonadDSL[F, B] = flatMap(f andThen MonadDSL.pure)
}
object MonadDSL {
  def pure[F[_], A](a: A): MonadDSL[F, A] = Val(a)
}
final case class Val[F[_], A](a: A) extends MonadDSL[F, A]
final case class Bind[F[_], A, B](pa: MonadDSL[F, B])(val f: B => MonadDSL[F, A]) extends MonadDSL[F, A]
final case class Op[F[_], A](op: F[A]) extends MonadDSL[F, A] 

// Code snippet 00038:
def run[F[_], A](runner: F[A] => A): MonadDSL[F, A] => A = { 
  case Val(a)          => a
  case bind@Bind(pa)   => run(runner)(bind.f(run(runner)(pa)))
  case Op(op)          => runner(op)
}

// Code snippet 00039:
def runComplexC[X]: PrgComplexC[X] => X    
def runFileC[X]: PrgFileC[X] => X          

// Code snippet 00040:
trait Runner[F[_]] { def run[X]: F[X] => X }
val runnerComplex = new Runner[PrgComplexC] { def run[X]: PrgComplexC[X] => X = runComplexC[X] }
val runnerFile = new Runner[PrgFileC] { def run[X]: PrgFileC[X] => X = runFileC[X] } 

// Code snippet 00041:
type Runner[F[_]] = [X] => F[X] => X

// Code snippet 00042:
def run[F[_], A](runner: Runner[F]): MonadDSL[F, A] => A = {
  case Val(a)          => a
  case bind@Bind(pa)   => run(runner)(bind.f(run(runner)(pa)))
  case Op(op)          => runner.run(op)
}

// Code snippet 00043:
type PrgComplex[A] = MonadDSL[PrgComplexC, A]
val prgComplex: PrgComplex[Complex] = for {
  x <- Op(Add(Complex(1, 1), Complex(0, 1)))
  y <- Op(Mul(x, Complex(3, -4)))
  z <- Op(Conj(y))
  r <- Op(Rotate(x, Phase(Complex(0, 1))))
} yield r

runComplex(runnerComplex)(prgComplex2)
 .mustBe[Complex] equal Complex(x = 2.000000000000001, y = 11.0)

// Code snippet 00044:
sealed trait F[_]

// Code snippet 00045:
final case class ReadPWriteQ(x: P) extends F[Q]

// Code snippet 00046:
sealed trait PrgFileC[_]
final case class Path(p: String) extends PrgFileC[JPath]
final case class Read(p: JPath)  extends PrgFileC[String]

// Code snippet 00047:
val runF: Runner[F] = new Runner[F] { def run[X]: F[X] => X = ??? }

// Code snippet 00048:
val runnerFile = new Runner[PrgFileC] { def run[X]: (PrgFileC[X] => X) = runFileC[X] }

// Code snippet 00049:
type MyDSL[A] = MonadDSL[F, A]
def runMyDSL[A]: MyDSL[A] => A = MonadDSL.run(runF)

// Code snippet 00050:
type FileDSL[A] = MonadDSL[PrgFileC, A]
def runFileDSL[A]: FileDSL[A] => A = MonadDSL.run(runnerFile)
val prgFile1: FileDSL[String] = for {
  x <- Op(Path("config.txt"))
  y <- Op(Read(x))
} yield y

runFileDSL(prgFile1)
 .mustBe[String] equal "version = 1"

// Code snippet 00051:
implicit def toOp[A](p: PrgFileC[A]): Op[A] = Op(p) 
val prgFile2: FileDSL[String] = for { 
  x <- Path("config.txt")
  y <- Read(x)
} yield y

runFileDSL(prgFile1)
 .mustBe[String] equal "version = 1"

// Code snippet 00052:
MonadDSL.pure(a).flatMap(f) == Bind(Val(a))(f) 

// Code snippet 00053:
r(MonadDSL.pure(a).flatMap(f)) == r(Bind(Val(a))(f)) == r(f(a))

// Code snippet 00054:
/* left-hand side:  */   p.flatMap(x => f(x).flatMap(g)) == Bind(p)(x => Bind(f(x))(g))
/* right-hand side: */   p.flatMap(f).flatMap(g) == Bind(Bind(p)(f))(g)

// Code snippet 00055:
/* left-hand side:  */   r(Bind(p)(x => Bind(f(x))(g))) == r(Bind(f(r(p)))(g)) == r(g(r(f(r(p)))))  
/* right-hand side: */   r(Bind(Bind(p)(f))(g)) == r(g(r(Bind(p)(f)))) == r(g(r(f(r(p)))))

// Code snippet 00056:
sealed trait MonadDSL[F[_], A] { *** check that this code works
  def flatMap[B](f: A => MonadDSL[F, B]): MonadDSL[F, B] = this match {
    case Val(a)          => f(a)
    case bind@Bind(pa)   => Bind(pa)(x => Bind(bind.f(x))(f))
    case _               => Bind(this)(f)
  }
  ... 
}

// Code snippet 00057:
p.flatMap(f andThen MonadDSL.pure) == p.map(f)

// Code snippet 00058:
trait RunnerTry[F[_]] { def run[X]: F[X] => Try[X] }
val runnerFileTry = new RunnerTry[PrgFileC] { def run[X]: PrgFileC[X] => Try[X] = p => Try(runFileC(p)) }

// Code snippet 00059:
def runTry[F[_], A](runnerTry: RunnerTry[F]): MonadDSL[F, A] => Try[A] = {
  case Val(a)          => Success(a)
  case bind@Bind(pa)   => runTry(runner)(pa).flatMap(bind.f andThen runTry(runner)) 
  case Op(op)          => runner.run(op)
} *** check that this code works

// Code snippet 00060:
trait RunnerM[F[_], M[_]] { def run[X]: F[X] => M[X] }
def runM[F[_], M[_]: Monad, A](runnerM: RunnerM[F, M]): MonadDSL[F, A] => M[A] = {
  case Val(a)          => Monad[M].pure(a)
  case bind@Bind(pa)   => runM(runnerM)(pa).flatMap(bind.f andThen runM(runnerM)) 
  case Op(op)          => runnerM.run(op)
} *** check that this code works

// Code snippet 00061:
run(MonadDSL.pure(a)) == run(Val(a))  == Monad[M].pure(a)
run(p.flatMap(f)) == run(Bind(p)(f)) == run(p.flatMap(f andThen run))

// Code snippet 00062:
abstract class Free1[F[_]: Functor, T] {
  def flatMap[A](f: T => Free1[F, A]): Free1[F, A] = this match {
    case Pure(t)      => f(a)
    case Flatten(p)   => Flatten(p.map(g => g.flatMap(f))) 
  }
}
final case class Pure[F[_], T](t: T)                 extends Free1[F, T]
final case class Flatten[F[_], T](p: F[Free1[F, T]]) extends Free1[F, T] 

// Code snippet 00063:
sealed trait Free2[F[_], T] {
  def flatMap[A](f: T => Free2[F, A]): Free2[F, A] = this match {
    case Return(t)    => f(t)
    case Bind(p, g)   => Bind(p, (b => g(b) flatMap f))
  }
}
final case class Return[F[_], T](t: T)                          extends Free2[F, T]
final case class Bind[F[_], T, A](p: F[A], g: A => Free2[F, T]) extends Free2[F, T]

// Code snippet 00064:
sealed trait Free3[F[_], T] {
  def flatMap[A](f: T => Free3[F, A]): Free3[F, A] = FlatMap(this, f) 
}
final case class Pure[F[_], T](t: T)                                      extends Free3[F, T]
final case class Suspend[F[_], T](f: F[T])                                extends Free3[F, T]
final case class FlatMap[F[_], T, A](p: Free3[F, A], g: A => Free3[F, T]) extends Free3[F, T]

// Code snippet 00065:
sealed trait Free4[F[_], A] {
  def flatMap[B](f: A => Free4[F, B]): Free4[F, B] = Bind(this)(f)
  def map[B](f: A => B): Free4[F, B] = FMap(this)(f)
}
object Free4 {
  def pure[F[_], A](a: A): Free4[F, A] = Val(a)
}
final case class Val[F[_], A](a: A)                                            extends Free4[F, A]
final case class Bind[F[_], A, B](pa: Free4[F, B])(val f: B => Free4[F, A])    extends Free4[F, A]
final case class FMap[F[_], A, B](pa: Free4[F, B])(val f: B => A)              extends Free4[F, A]
final case class Op[F[_], A](op: F[A]) extends Free4[F, A] 

// Code snippet 00066:
def run[F[_], A](runner: Runner[F]): Free4[F, A] => A = {
  case Val(a)            => a
  case bind @ Bind(pa)   => run(runner)(bind.f(run(runner)(pa)))
  case fmap @ FMap(pa)   => fmap.f(run(runner)(pa))
  case Op(op)            => runner.run(op)
} *** check that this code works

// Code snippet 00067:
p.map(f) == p.flatMap (f andThen pure)

// Code snippet 00068:
def free4toFree3[F[_], A]: Free4[F, A] => Free3[F, A] = {
  case fmap @ FMap(p)   => Bind(free4toFree3(p))(fmap.f andThen Free3.pure) 
  case Val(a)           => Val(a)                                  
  case bind@Bind(p)     => Bind(free4toFree3(p))(bind.f)
  case Op(op)           => Op(op)
}

// Code snippet 00069:
def free3toFree4[F[_], A]: Free3[F, A] => Free4[F, A] = {
  case Val(a)           => Val(a)
  case bind@Bind(p)     => Bind(free3toFree4(p))(bind.f)
  case Op(op)           => Op(op)
}

// Code snippet 00070:
runFree4(runner)(free4program) == runFree3(runner)(free4toFree3(free4program))
runFree3(runner)(free3program) == runFree4(runner)(free3toFree4(free3program))

// Code snippet 00071:
runFree4(runner)(p) == runFree4(runner)(FMap(q)(f)) == f(runFree4(runner)(q))

// Code snippet 00072:
free4toFree3(p) == Bind(q)(f andThen Free3.pure)

// Code snippet 00073:
runFree3(runner)(free4toFree3(p)) == runFree3(runner)(Bind(free4toFree3(q))(f andThen Free3.pure))
   == runFree3(runner)(Free3.pure(f(runFree3(runner)(free4toFree3(q)))))
   == runFree3(runner)(Pure(f(runFree3(runner)(free4toFree3(q)))))
   == f(runFree3(runner)(free4toFree3(q))))

// Code snippet 00074:
f(runFree4(runner)(q)) == f(runFree3(runner)(free4toFree3(q))))

// Code snippet 00075:
def free2toFree3[F[_], A]: Free2[F, A] => Free3[F, A] = {
  case Return(a)    => Pure(a)
  case Bind(p, g)   => FlatMap(Suspend(p), g andThen free2toFree3)
}

// Code snippet 00076:
def free3toFree2[F[_], A]: Free3[F, A] => Free2[F, A] = {
  case Pure(a)         => Return(a)
  case Suspend(f)      => Bind(f, a => Return(a))
  case FlatMap(p, g)   => ???
}

// Code snippet 00077:
sealed trait MonadDSL[F[_], T] {
  def flatMap[A](...) = ...
  def map[A](f: T => A): MonadDSL[F, A] = Bind(this)(f andThen MonadDSL.pure)
}
final case class Val[F[_], T](t: T)                                          extends MonadDSL[F, T]
final case class Op[F[_], T](f: F[T])                                        extends MonadDSL[F, T]
final case class Bind[F[_], T, A](p: MonadDSL[F, A])(g: A => MonadDSL[F, T]) extends MonadDSL[F, T]

// Code snippet 00078:
val p: MonadDSL[F, Int] = ...
val q: MonadDSL[F, String] = p.map { i: Int => s"value = $i" }     

// Code snippet 00079:
sealed trait L[A, B]
final case class L1[A, B, C](a: A, c: C, p: C => B) extends L[A, B]

// Code snippet 00080:
val q1: L[Int, Int] = L1[Int, Int, String](1, "abc", _.length)

// Code snippet 00081:
def toInt: L[Int, Int] => Int = {
  case L1(a, c, p) => a + p(c) 
}

toInt(q1)
 .mustBe[Int] equal 4

// Code snippet 00082:
trait L2[A, B] {
  type C
  val a: A
  val c: C
  val p: C => B
}
val q2: L2[Int, Int] = new L2[Int, Int] {
  type C = String
  val a: Int = 1
  val c: String = "abc"
  val p: String => Int = _.length
}
def toInt(q: L2[Int, Int]): Int = q.a + q.p(q.c)

toInt(q2)
 .mustBe[Int] equal 4

// Code snippet 00083:
val x: q2.C = "abc"        
                    ^
error: type mismatch;
found   : String("abc")
required: q2.C

// Code snippet 00084:
def toIntL1[C]: L1[Int, Int, C] => Int = { case L1(a, c, p) => a + p(c) }

// Code snippet 00085:
def f[A]: F[A] = ...

// Code snippet 00086:
def f[A, B, C](a: A, c: C, p: C => B): L[A, B] = L1(a, c, p) 

// Code snippet 00087:
sealed trait FreeDefault[T]
final case class Default[T](unit: Unit) extends FreeDefault[T]
final case class Op[T](op: T) extends FreeDefault[T]

// Code snippet 00088:
type FreeDefault[T] = Option[T]

// Code snippet 00089:
def runner[T, P: HasDefault](run: T => P): Option[T] => P = {
  case Some(t)   => run(t)
  case None      => implicitly[HasDefault[P]].value          
}

// Code snippet 00090:
runner(run)(x) == x.map(run).getOrElse(implicitly[HasDefault[P]].value)

// Code snippet 00091:
sealed trait FSR[T]
final case class Combine[T](left: FSR[T], right: FSR[T]) extends FSR[T]
final case class Wrap[T](value: T) extends FSR[T]

// Code snippet 00092:
implicit def semigroupFSR[T]: Semigroup[FSR[T]] = Semigroup((l, r) => Combine(l, r)) *** verify code

// Code snippet 00093:
implicit class SemigroupOp[S: Semigroup](s: S) {
  def |+|(other: S): S = implicitly[Semigroup[S]].combine(s, other)
}*** check if it works

// Code snippet 00094:
def runner[S: Semigroup, T](runT: T => S): FSR[T] => S = {
  case Combine(left, right)   => runner(runT)(left) |+| runner(runT)(right)
  case Wrap(value)            => runT(value)
}

// Code snippet 00095:
val fsfProgram: FSR[String] = Wrap("abc") |+| (Wrap("xyz") |+| Wrap(""))

// Code snippet 00096:
*** test that this works
implicit semigroupInt: Semigroup[Int] = Semigroup(_ + _)

runner(_.length)(fsfProgram)
 .mustBe[Int] equal 6

// Code snippet 00097:
implicit def semigroupFSR[T]: Semigroup[FSR[T]] = Semigroup((l, r) => l match {
  case Wrap(value)     => Combine(l, r)
  case Combine(p, q)   => p |+| (q |+| r) 
}) *** verify that this code works

// Code snippet 00098:
implicit def semigroupNEL[T]: Semigroup[NEL[T]] = Semigroup((l, r) => concat(l, r))
 
@tailrec def runner[S: Semigroup, T](runT: T => S)(n: NEL[T]): S = n match {
  case Last(x)        => runT(x)
  case More(x, tail)  => runner(runT)(tail)
}

// Code snippet 00099:
sealed trait FMR[T]
final case class Combine[T](left: FMR[T], right: FMR[T]) extends FMR[T]
final case class Empty[T]() extends FMR[T]
final case class Wrap[T](value: T) extends FMR[T]

// Code snippet 00100:
implicit def monoidFMR[T]: Monoid[FMR[T]] = Monoid((l, r) => Combine(l, r), Empty())

// Code snippet 00101:
def runnerFMR[M: Monoid, T](runT: T => M)(fmr: FMR[T]): M = fmr match {
  case Combine(left, right)   => runnerFMR(runT)(left) |+| runnerFMR(runT)(right)
  case Empty()                => Monoid[M].empty
  case Wrap(value)            => runT(value)
}

// Code snippet 00102:
def runnerList[M: Monoid, T](runT: T => M): List[T] => M = foldMap[M, T](runT)

// Code snippet 00103:
type F1[T] = Tree2[Option[T]]
def wrapF1[T](t: T): F1[T] = Leaf(Some(t))
implicit def monoidF1[T]: Monoid[F1[T]] = Monoid((l, r) => Branch(l, r), Leaf(None))
def runnerF1[M: Monoid, T](runT: T => M)(fmr: F1[T]): M = fmr match {
  case Branch(left, right)   => runnerF1(runT)(left) |+| runnerF1(runT)(right)
  case Leaf(None)            => Monoid[M].empty
  case Leaf(Some(value))     => runT(value)
}

// Code snippet 00104:
type F2[T] = NEL[Option[T]]
def wrapF2[T](t: T): F2[T] = (Some(t), Nil)
implicit def monoidF2[T]: Monoid[F2[T]] = Monoid(NEL.concat, (None, Nil))
def runnerF2[M: Monoid, T](runT: T => M)(fmr: F2[T]): M = foldMap(runT).apply(fmr.toList.flatten) 

// Code snippet 00105:
type NEL[T] = (T, List[T])
object NEL {
  def concat[T]: (NEL[T], NEL[T]) => NEL[T] = {
    case ((head1, tail1), (head2, tail2)) => (head1, tail1 ++ List(head2) ++ tail2)
  }
  implicit class ToList[T](nel: NEL[T]) {
    def toList: List[T] = nel._1 +: nel._2
  }
}

// Code snippet 00106:
type F3[T] = Option[Tree2[T]]
def wrapF3[T](t: T): F3[T] = Some(Leaf(t))
def concatF3[T]: (F3[T], F3[T]) => F3[T] = {
  case (None, x)            => x
  case (x, None)            => x
  case (Some(a), Some(b))   => Some(Branch(a, b))
}
def wrapF3[T](t: T): F3[T] = Some(Leaf(t))
implicit def monoidF3[T]: Monoid[F3[T]] = Monoid(concatF3, None)
def runnerTree2[M: Monoid, T](runT: T => M)(tree2: Tree2[T]): M = tree2 match {
  case Leaf(a)               => runT(a)
  case Branch(left, right)   => runnerTree2(runT)(left) |+| runnerTree2(runT)(right)
}
def runnerF3[M: Monoid, T](runT: T => M)(fmr: F3[T]): M = fmr match {
  case Some(t)   => runnerTree2(runT)(t)
  case None      => Monoid[M].empty
}

// Code snippet 00107:
type F4[T] = List[T]
def wrapF4[T](t: T): F4[T] = List(t)
implicit def monoidF4[T]: Monoid[F4[T]] = Monoid(_ ++ _, Nil)
def runnerF4[M: Monoid, T](runT: T => M)(fmr: F4[T]): M = foldMap(runT).apply(fmr)

// Code snippet 00108:
def f1_to_f2[T]: F1[T] => F2[T] = runnerF1(wrapF2[T](_))
def f3_to_f2[T]: F3[T] => F2[T] = runnerF3(wrapF2[T](_))
def f4_to_f3[T]: F4[T] => F3[T] = runnerF4(wrapF3[T](_)) 

// Code snippet 00109:
f4_to_f3(List(1, 2, 3))
 .mustBe[F3[Int]] equal Some(Branch(Branch(Leaf(1), Leaf(2)), Leaf(3)))

// Code snippet 00110:
f4_to_f3(List(1)) |+| f4_to_f3(List(2, 3))
 .mustBe[F3[Int]] equal Some(Branch(Leaf(1), Branch(Leaf(2), Leaf(3))))

// Code snippet 00111:
sealed trait FFR[F[_], A] {
  def map[B](f: A => B): FFR[F, B] = FMap(f, this)
}
final case class FMap[F[_], X, Y](f: X => Y, p: FFR[F, X]) extends FFR[F, Y]
final case class Op[F[_], A](op: F[A]) extends FFR[F, A]

// Code snippet 00112:
def runFFR[F[_], A](runner: Runner[F]): FFR[F, A] => A = {
  case FMap(f, p)   => f(runFFR(runner)(p))
  case Op(op)       => runner.run(op)
}*** check if this works

// Code snippet 00113:
final case class FMap[F[_], X, Y](f: X => Y, p: FFR[F, X]) extends FFR[F, Y] {
  def map[Z](g: Y => Z): FFR[F, Z] = FMap[F, X, Z](f andThen g, p)
}

// Code snippet 00114:
sealed trait FF[F[_], A] {
  def map[B](f: A => B): FF[F, B]
}
final case class FMap[F[_], X, Y](f: X => Y, p: F[X]) extends FF[F, Y] {
  def map[Z](g: Y => Z): FF[F, Z] = FMap[F, X, Z](f andThen g, p)
}
def runFF[F[_], A](runner: Runner[F]): FF[F, A] => A = {
  case FMap(f, p)   => f(runner.run(p))
}*** check if this works

// Code snippet 00115:
sealed trait FFS[F[_], A] {
  def map[B](f: A => B): FFS[F, B]
}
final case class FMap[F[_], X, Y](f: FuncSeq[X, Y], p: F[X]) extends FFS[F, Y] {
  def map[Z](g: Y => Z): FFS[F, Z] = FMap[F, X, Z](f append g, p)
}
def runFF[F[_], A](runner: Runner[F]): FFS[F, A] => A = {
 case FMap(f, p) => runSeq(runner.run(p), f)
}*** check if this works

// Code snippet 00116:
def monoidOnSemi[T: Semigroup]: Monoid[Option[T]] = Monoid(
  (l, r) => (l zip r).map { case (x, y) => x |+| y },
  None) *** verify code

// Code snippet 00117:
sealed trait Free5[F[_], A]
final case class Pure[F[_], A](a: A) extends Free5[F, A]
final case class Wrap[F[_], A](fa: F[A]) extends Free5[F, A]
final case class Flatten[F[_], A](ff: Free5[F, Free5[F, A]]) extends Free5[F, A]

// Code snippet 00118:
def lhs1[T](t: T): FMR[T] = Combine(Empty(), Wrap(t))
def rhs1[T](t: T): FMR[T] = Wrap(t)

// Code snippet 00119:
def lhs1Evaluated[T: Monoid](t: T): T = runner[T, T](identity)(lhs1(t))
def rhs1Evaluated[T: Monoid](t: T): T = runner[T, T](identity)(rhs1(t))

// Code snippet 00120:
forAll { t: T =>               
  lhs1Evaluated(t) shouldEqual rhs1Evaluated(t)
}

// Code snippet 00121:
def lhs3[T](t1: T, t2: T, t3: T): FMR[T] = Combine(Combine(Wrap(t1), Wrap(t2)), Wrap(t3))
def rhs3[T](t1: T, t2: T, t3: T): FMR[T] = Combine(Wrap(t1), Combine(Wrap(t2), Wrap(t3)))

// Code snippet 00122:
def lhs3Evaluated[T: Monoid](t1: T, t2: T, t3: T): T = runner[T, T](identity)(lhs3(t1, t2, t3))
def rhs3Evaluated[T: Monoid](t1: T, t2: T, t3: T): T = runner[T, T](identity)(rhs3(t1, t2, t3))

// Code snippet 00123:
forAll { (t1: T, t2: T, t3: T) =>               
  lhs3Evaluated(t1, t2, t3) shouldEqual rhs3Evaluated(t1, t2, t3)
}

// Code snippet 00124:
val f: Int => T = ...
val (lhs: FPR[T], rhs: FPR[T]) = et(f)

// Code snippet 00125:
val (lhsT: T, rhsT: T) = (runner(id)(lhs), runner(id)(rhs))

// Code snippet 00126:
trait FSCh[Z] { def run[S](empty: Z => S, combine: (S, S) => S): S }
def fsz2ch[Z](fsz: NEList[Z]): FSCh[Z] = ???
def ch2fsz[Z](ch: FSCh[Z]): NEList[Z] = ???

// Code snippet 00127:
sealed trait TIO[A]
final case class Pure[A](a: A) extends TIO[A]
final case class Read[A](read: P => TIO[A]) extends TIO[A]
final case class Write[A](output: Q, next: TIO[A]) extends TIO[A]

// Code snippet 00128:
def f[X]: F[X] = ???

// Code snippet 00129:
trait TC[F[_]] { def run[X](fold: F[X] => X): X }

// Code snippet 00130:
def toAny[T](t: T): Any = t

// Code snippet 00131:

  }
