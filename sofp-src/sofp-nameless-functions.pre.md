implicit class MustBeOp[A](val x: A) extends AnyVal {
	def mustBe[B >: A](y: B): Unit = assert(x == y)
}

val n: Int = 10 // Defined in the text.

