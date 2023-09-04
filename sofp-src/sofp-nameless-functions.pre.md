import scala.util.{Failure, Try}

object tools {
  implicit class MustBeOp[A](x: => A) {
    def mustBe[B >: A]: B = { assert(x.isInstanceOf[B]); x : B }
    def equal[B >: A](y: B): Unit = assert(x == y)
    def mustThrow[T](message: String): Unit = assert(Try(x) match { case Failure(t: T) if t.getMessage == message => true } )
  }
}
import tools._

val n: Int = 10 // Defined in the text.

