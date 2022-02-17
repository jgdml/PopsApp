class LoginError{

  String cause;

  LoginError(this.cause);
  @override
  String toString(){
    return this.cause;
  }
}