{ qtModule, qtbase }:

qtModule {
  name = "qtgamepad";
  qtInputs = [ qtbase ];
  outputs = [ "out" "dev" "bin" ];
}
